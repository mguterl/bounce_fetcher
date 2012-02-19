# lifted from the action_mailer_verp plugin:
# http://github.com/jamesgolick/action_mailer_verp

require 'net/pop'

module BounceFetcher

  class PopFetcher

    class Email
      def initialize(email)
        @email = email
      end

      def delete
        @email.delete
      end

      def method_missing(meth, *args, &block)
        parsed_email.send(meth, *args, &block)
      end

      private

      def parsed_email
        @parsed_email ||= TMail::Mail.parse(fetch_mail)
      end

      def fetch_mail
        @email.pop
      rescue Timeout::Error => e
        attempts ||= 1
        retry unless attempts > 3
      end
    end

    def initialize(host, username, password, port = 110)
      @host = host
      @username = username
      @password = password
      @port = port
    end

    def each
      connection.each_mail do |e|
        yield Email.new(e)
      end
      connection.finish
    end

    private

    def connection
      if @connection.nil?
        @connection = Net::POP3.new(@host, @port)
        @connection.start(@username, @password)
      end

      @connection
    end

  end

end
