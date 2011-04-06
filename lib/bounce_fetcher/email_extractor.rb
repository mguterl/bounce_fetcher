module BounceFetcher

  class EmailExtractor

    EMAIL_REGEX = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i

    def extract_emails(string)
      string.scan(EMAIL_REGEX).compact.uniq
    end

  end

end
