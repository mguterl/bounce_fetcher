module BounceFetcher

  def self.new(*args, &block)
    BounceFetcher.new(*args, &block)
  end

  def self.pop3(host, username, password, port = 110)
    fetcher = PopFetcher.new(host, username, password, port)
    extractor = EmailExtractor.new
    detector = BounceDetector.new
    new(fetcher, extractor, detector)
  end

  class BounceFetcher

    def initialize(fetcher, extractor, detector)
      @fetcher = fetcher
      @extractor = extractor
      @detector = detector
    end

    def each(options = {})
      options = { :delete => true }.merge(options)

      @fetcher.each do |e|
        if @detector.permanent_bounce?(e)
          @extractor.extract_emails(e.body).each do |email|
            yield email
          end
          e.delete if options[:delete]
        end
      end
    end

  end

end

require 'bounce_fetcher/pop_fetcher'
require 'bounce_fetcher/email_extractor'
require 'bounce_fetcher/bounce_detector'
