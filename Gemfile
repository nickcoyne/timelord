source 'https://rubygems.org'

ruby '2.3.1'

gem 'sinatra'
gem 'chronic'
gem 'activesupport'
gem 'dotenv'

group :development do
  gem 'better_errors'
  gem 'foreman'
  gem 'puma'
  gem 'rubocop'
end

group :production do
  gem 'puma'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'minitest', require: 'minitest/autorun'
  gem 'minitest-rg'
  gem 'minitest-spec-context'
  gem 'mocha', '~> 1.1.0', require: false
  gem 'multi_json'
  gem 'rack-test', require: 'rack/test'
  gem 'rake'
  gem 'timecop'
end
