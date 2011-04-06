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

  class Email < Struct.new(:body, :permanent_bounce); end

  class FakeExtractor
    def extract_emails(tmail)
      [tmail.body]
    end
  end

  class FakeBounceDetector
    def permanent_bounce?(tmail)
      tmail.permanent_bounce
    end
  end

  def test_each_only_returns_emails_for_permanent_bounces
    pop_fetcher = FakePopFetcher.new(Email.new('foo@bar.com', true), Email.new('bar@baz.com', false))
    extractor = FakeExtractor.new
    detector = FakeBounceDetector.new
    fetcher = BounceFetcher.new(pop_fetcher, extractor, detector)

    emails = []
    fetcher.each do |email|
      emails << email
    end

    assert_equal ['foo@bar.com'], emails
  end

end
