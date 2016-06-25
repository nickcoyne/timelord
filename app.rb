require 'bundler/setup'
require 'dotenv'
require 'sinatra'
require 'json'
require 'timebot/calculator'

Dotenv.load

module TimeBot
  class Api < Sinatra::Base
    def authorize!
      return if params['token'] == ENV['SLACK_TOKEN']
      halt 401
    end

    get '/time' do
      authorize!
      message, emoji = TimeBot::Calculator.new.do_times(params[:text])
      status 200

      reply = { username: 'timelord', icon_emoji: emoji, text: message }
      reply.to_json
    end

    post '/time' do
      authorize!
      message, emoji = TimeBot::Calculator.new.do_times(params['text'])
      status 200

      reply = { username: 'timelord', icon_emoji: emoji, text: message }
      reply.to_json
    end
  end
end
