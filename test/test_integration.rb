require 'minitest/autorun'
require 'bounce_fetcher'
require 'net/smtp'

class TestIntegration < MiniTest::Unit::TestCase

  def start_server
    child_pid = fork do
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
    mail.subject = options[:subject] || 'mail delivery failed'
    mail.body    = options[:body] || 'foo@bar.com mailbox unavailable'
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

  def setup
    start_server
    send_email # bounce
    send_email(:subject => 'hi', :body => 'there') # not bounce
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
