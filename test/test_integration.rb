require 'minitest/autorun'
require 'bounce_fetcher'
require 'net/smtp'

class TestIntegration < MiniTest::Unit::TestCase

  def start_server
    fork do
      STDIN.reopen('/dev/null')
      STDOUT.reopen('/dev/null', 'a')
      STDERR.reopen(STDOUT)
      Dir.chdir(File.dirname(__FILE__) + "/support/localpost")
      exec("ruby -I. localpost.rb")
    end
  end

  def send_email(options = {})
    mail = TMail::Mail.new

    mail.to      = options[:to] || 'blah@blah.com'
    mail.from    = options[:from] || 'postmaster@blah.com'
    mail.subject = options[:subject] || 'subject'
    mail.body    = options[:body] || 'body'
    mail.date    = options[:date] || Time.now

    begin
      Net::SMTP.start('127.0.0.1', 25000) do |smtp|
        smtp.send_message(mail.to_s, mail.from, mail.to)
      end
    rescue Errno::ECONNREFUSED => e
      sleep 0.1
      retry
    end
  end

  def send_permanent_bounce(options = {})
    options = {
      :subject => 'mail delivery failed',
      :body => 'foo@bar.com mailbox unavailable',
    }.merge(options)

    send_email(options)
  end

  def setup
    start_server
    send_permanent_bounce
    send_email
  end

  def test_bounce_fetcher
    bounces = BounceFetcher.pop3('127.0.0.1', 'localpost', 'localpost', 11000)

    emails = []
    bounces.each do |email|
      emails << email
    end

    assert_equal ['foo@bar.com'], emails
  end

end
