require_relative '../../spec_helper'

describe TimeBot::Calculator, :unit do
  let(:timebot) { TimeBot::Calculator.new }

  describe '#time_in_zones' do
    context 'invalid params' do
      it 'returns nil array' do
        timebot.time_in_zones('test').must_equal [nil, nil]
      end
    end

    context 'time with zone' do
      it 'returns time offset from zone time (EST)' do
        timebot.time_in_zones(
          '#E 10:25'
        ).must_equal [
          '> 07:25am PDT | 08:25am MDT | 09:25am CDT | 10:25am EDT | ' \
          '09:25am COT | 04:25pm CEST | 02:25am NZST',
          ':clock10:'
        ]
      end

      it 'returns time offset from zone time (NZDT)' do
        timebot.time_in_zones(
          '#NZ 10:25'
        ).must_equal [
          '> 03:25pm PDT | 04:25pm MDT | 05:25pm CDT | 06:25pm EDT | ' \
          '05:25pm COT | 12:25am CEST | 10:25am NZST',
          ':clock10:'
        ]
      end
    end

    context 'zone only' do
      it 'returns current time in zones' do
        Timecop.freeze('2016-06-25 17:30') do
          timebot.time_in_zones(
            '#E'
          ).must_equal [
            '> 02:30pm PDT | 03:30pm MDT | 04:30pm CDT | 05:30pm EDT | ' \
            '04:30pm COT | 11:30pm CEST | 09:30am NZST',
            ':clock5:'
          ]
        end
      end
    end
  end
end
