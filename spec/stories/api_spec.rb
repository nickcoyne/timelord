require_relative '../story_helper.rb'

describe 'TimeBot::Api::Story', :story do
  context 'without token' do
    it 'responds with 401' do
      get '/time'
      last_response.status.must_equal 401
    end
  end

  context 'invalid params' do
    it 'returns nulls' do
      post(
        '/time',
        text: 'test',
        token: ENV['SLACK_TOKEN']
      )
      response = json_parse(last_response.body)
      response.must_equal({
        username: 'timelord',
        icon_emoji: nil,
        text: nil
      })
    end
  end

  context 'valid params' do
    it 'returns response' do
      post(
        '/time',
        text: '#E 10:25',
        token: ENV['SLACK_TOKEN']
      )
      response = json_parse(last_response.body)
      response.must_equal({
        username: 'timelord',
        icon_emoji: ':clock10:',
        text: '> 07:25am PDT | 08:25am MDT | 09:25am CDT | 10:25am EDT | ' \
              '03:25pm BST | 04:25pm CEST'
      })
    end

  end
end
