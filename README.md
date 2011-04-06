# Bounce Fetcher

A set of tools for processing email bounces in a flexible way.

## Usage

    bounces = BounceFetcher.pop3('pop3.host.com', 'username', 'password')
    bounces.each do |email|
      # do something application specific
      # For example: User.bounce_email(email)
    end

This will fetch each email from the POP3 server specified, if the email is a determined to be a permanent bounce, we will attempt to determine what email address the bounce is for, yield it to the block, and the email will be deleted from the POP3 server.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Michael Guterl. See LICENSE for details.
