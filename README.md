## Setup

* Clone the repo
* $ bundle
* Modify config/database.yml.example to your liking, rename to config/database.yml
* Edit config/application.yml.example and rename to application.yml
* $ bundle exec rake db:setup

## Web Hook

**NOTE:** You need an account on Postmark.

**NOTE:** You need some way for Postmark to POST to your server
(localhost). ForwardHQ is the easiest way to do this, but costs
a little money ($5/mo). Localtunnel is an option, but gives you
a different URL each time you launch it, which means you need to
update your Postmark inbound URL *every time you bounce*.

Additional option: ngrok. http://ngrok.com

* Set up a new Server in your Rack on Postmark
* Under settings, add an inbound hook url,
  `https://forward.server/api/nuggets`

## Running

* Start the server locally.
* Start the forwarder
* Email your API address (from Postmark -> Credentials -> Inbound)
* Watch Postmark -> Inbound dashboard and local console log for evidence
  of processing.


