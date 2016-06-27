[![Build Status](https://travis-ci.org/nickcoyne/timelord.svg?branch=master)](https://travis-ci.org/nickcoyne/timelord) [![Code Climate](https://codeclimate.com/github/nickcoyne/timelord/badges/gpa.svg)](https://codeclimate.com/github/nickcoyne/timelord) [![Test Coverage](https://codeclimate.com/github/nickcoyne/timelord/badges/coverage.svg)](https://codeclimate.com/github/nickcoyne/timelord/coverage)


## Overview

TimeLord is a lightweight Sinatra app that provides [Slack](http://slack.com/). Once setup, you can type `#e,#p,#m,or #c` in your Slack channel and TimeLord will post the time in various time zones.

At [Baremetrics](https://baremetrics.com), we're a distributed team (spanning six different timezones) so when we mention various times in Slack, it can get confusing about what time that means for each person. TimeLord solves that.

![TimeLord Example](https://s3.amazonaws.com/f.cl.ly/items/0g1G0u2B2e000e3m0P1s/timelord.png)

## Usage

### Preparation

TimeLord uses a Slack [Outgoing WebHooks](https://slack.com/services/new/outgoing-webhook) integration for catching the `#e,#p,#m,or #c` request and firing it to your TimeLord service. You'll need to [add a new Outgoing WebHook](https://slack.com/services/new/outgoing-webhook) first so you'll have the `SLACK_TOKEN` available for the actual TimeLord deployment steps below.

### Enabled zones

Use the `TIMELORD_ZONES` environment variable to set which zones you would like to appear in the response. Eg. `e,p,m,c`

### Deployment

#### Local

```
$ bundle install
$ export SLACK_TOKEN=...
$ export TIMELORD_ZONES=...
$ foreman start
```

#### Heroku

```
$ heroku create
$ heroku config:set SLACK_TOKEN=...
$ heroku config:set TIMELORD_ZONES=...
$ git push heroku master
```

### WebHook Settings

Once your TimeLord application has been deployed you'll need to go back to your Outgoing Webhook page and update the Integration Settings. Generally speaking you'll want to use settings like these (adjust as necessary):

* Channel: `Any`
* Trigger Word: `#e,#p,#m,#c`
* URL: `https://slack-TimeLord-123.herokuapp.com/time` (the `/time` endpoint is mandatory)
* Label: `TimeLord`
