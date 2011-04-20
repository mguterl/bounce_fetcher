require 'minitest/autorun'
require 'bounce_fetcher'

class TestBounceFetcher < MiniTest::Unit::TestCase

  class FakePopFetcher
    def initialize(*emails)
      @emails = emails
    end

    def each
      @emails.each { |email| yield email }
    end
  end

  class Email < Struct.new(:body, :permanent_bounce)
    def delete
      @deleted = true
    end

    def deleted?
      @deleted
    end
  end

  class FakeExtractor
    def extract_emails(string)
      [string]
    end
  end

  class FakeBounceDetector
    def permanent_bounce?(tmail)
      tmail.permanent_bounce
    end
  end

  def setup
    @permanent_bounce = Email.new('foo@bar.com', true)
    @temporary_bounce = Email.new('bar@baz.com', false)
    @pop_fetcher = FakePopFetcher.new(@permanent_bounce, @temporary_bounce)
    @extractor = FakeExtractor.new
    @detector = FakeBounceDetector.new
    @fetcher = BounceFetcher.new(@pop_fetcher, @extractor, @detector)
  end

  def test_each_only_returns_emails_for_permanent_bounces
    emails = []
    @fetcher.each do |email|
      emails << email
    end

    assert_equal ['foo@bar.com'], emails
    assert @permanent_bounce.deleted?
    assert !@temporary_bounce.deleted?
  end

  def test_each_with_no_delete_option
    emails = []

    @fetcher.each(:delete => false) do |email|
      emails << email
    end

    assert_equal ['foo@bar.com'], emails
    assert !@permanent_bounce.deleted?
    assert !@temporary_bounce.deleted?
  end

end
