require 'bundler/setup'
require 'dotenv'
require 'sinatra'
require 'json'
require 'time_bot/calculator'

Dotenv.load

module TimeBot
  class Api < Sinatra::Base
    SLACK_USER = 'timelord'.freeze

    def authorize!
      return if params['token'] == ENV['SLACK_TOKEN']
      halt 401
    end

    get '/time' do
      authorize!
      message, emoji = TimeBot::Calculator.new.time_in_zones(params[:text])
      status 200

      reply = { username: SLACK_USER, icon_emoji: emoji, text: message }
      reply.to_json
    end

    post '/time' do
      authorize!
      message, emoji = TimeBot::Calculator.new.time_in_zones(params['text'])
      status 200

      reply = { username: SLACK_USER, icon_emoji: emoji, text: message }
      reply.to_json
    end
  end
end
