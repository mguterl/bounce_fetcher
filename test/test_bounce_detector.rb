require 'minitest/autorun'
require 'bounce_fetcher'

class TestBounceDetector < MiniTest::Unit::TestCase

  class Email < Struct.new(:subject, :body)
    def parts
      []
    end
  end

  class EmailWithBounceStatus
    class Part < Struct.new(:body); end

    def subject
      "mail delivery failed"
    end

    def parts
      [nil, Part.new("Status: 5.2.0")]
    end
  end

  def setup
    @detector = BounceFetcher::BounceDetector.new
  end

  def test_permanent_bounce_with_temporary_failure
    assert !@detector.permanent_bounce?(Email.new("mail delivery failed"))
  end

  def test_permanent_bounce_with_out_of_town_auto_responder
    assert !@detector.permanent_bounce?(Email.new("Out of Town"))
  end

  def test_permanent_bounce_with_a_permanent_bounce_body
    assert @detector.permanent_bounce?(Email.new("mail delivery failed", "mailbox unavailable"))
  end

  def test_permanent_bounce_with_a_permanent_bounce_status
    assert @detector.permanent_bounce?(EmailWithBounceStatus.new)
  end

end
