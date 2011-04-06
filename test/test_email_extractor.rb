require 'minitest/autorun'
require 'bounce_fetcher'

class TestEmailExtractor < MiniTest::Unit::TestCase

  def setup
    @extractor = BounceFetcher::EmailExtractor.new
  end

  def test_extract_emails
    assert_equal ['foo@bar.com', 'bar@baz.com'], @extractor.extract_emails("foo@bar.com\nbar@baz.com")
  end

  def test_extract_emails_ignores_duplicates
    assert_equal ['foo@bar.com'], @extractor.extract_emails("foo@bar.com\nfoo@bar.com")
  end

end
