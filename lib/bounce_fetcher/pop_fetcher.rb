# lifted from the action_mailer_verp plugin:
# http://github.com/jamesgolick/action_mailer_verp

module BounceProcessor

  class PopFetcher

    def initialize(host, username, password)
      @host = host
      @username = username
      @password = password
    end

    def each
      connection.each_mail do |e|
        yield TMail::Mail.parse(e.pop)
        e.delete
      end
      connection.finish
    end

    private

    def connection
      if @connection.nil?
        @connection = Net::POP3.new(@host)
        @connection.start(@username, @password)
      end

      @connection
    end

  end

end
