require 'bounce-email'

module BounceFetcher

  class BounceDetector

    def permanent_bounce?(email)
      bounce = BounceEmail::Mail.new(email)
      bounce.isbounce && bounce.type == "Permanent Failure"
    end

  end

end
