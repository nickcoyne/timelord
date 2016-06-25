require_relative '../../spec_helper'

describe TimeBot::Calculator, :unit do
  let(:timebot) { TimeBot::Calculator.new }

  describe '#do_times' do
    context 'invalid params' do
      it 'returns nil array' do
        timebot.do_times('test').must_equal [nil, nil]
      end
    end

    context 'time with no zone' do
      it 'returns time based on UTC' do
        timebot.do_times(
          '10:25'
        ).must_equal [
          '> 03:25am PDT | 04:25am MDT | 05:25am CDT | 06:25am EDT | ' \
          '05:25am COT | 12:25pm CEST | 10:25pm NZST',
          ':clock10:'
        ]
      end
    end

    context 'time with zone' do
      it 'returns time offset from zone time (EST)' do
        timebot.do_times(
          '#E 10:25'
        ).must_equal [
          '> 07:25am PDT | 08:25am MDT | 09:25am CDT | 10:25am EDT | ' \
          '09:25am COT | 04:25pm CEST | 02:25am NZST',
          ':clock10:'
        ]
      end

      it 'returns time offset from zone time (NZDT)' do
        timebot.do_times(
          '#NZ 10:25'
        ).must_equal [
          '> 03:25pm PDT | 04:25pm MDT | 05:25pm CDT | 06:25pm EDT | ' \
          '05:25pm COT | 12:25am CEST | 10:25am NZST',
          ':clock10:'
        ]
      end
    end

    context 'zone only' do
      # it 'returns current time in zones' do
      #   timebot.do_times(
      #     '#E'
      #   ).must_equal [
      #     '> 07:25am PDT | 08:25am MDT | 09:25am CDT | 10:25am EDT | ' \
      #     '09:25am COT | 04:25pm CEST | 02:25am NZST',
      #     ':clock10:'
      #   ]
      # end
    end
  end
end
