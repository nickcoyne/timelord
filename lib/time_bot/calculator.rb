require 'chronic'
require 'active_support/core_ext/time'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/string'

module TimeBot
  class Calculator
    TRIGGER_MAP = {
      'US/Pacific' => %w(PDT PST PACIFIC P),
      'US/Mountain' => %w(MDT MST MOUNTAIN M),
      'US/Central' => %w(CDT CST CENTRAL C),
      'US/Eastern' => %w(EDT EST EASTERN E),
      'America/Bogota' => %w(COT CO),
      # 'Europe/London' => %w(BST B #B L LONDON),
      'Europe/Madrid' => %w(CEST CET CE),
      'Pacific/Auckland' => %w(NZDT NZST NZ)
    }.freeze

    def do_times(phrase)
      return [nil, nil] if phrase.blank?

      message = nil
      emoji = nil

      zone = zone_from_trigger(phrase.split.first.try(:upcase))

      Time.zone = zone
      Chronic.time_class = Time.zone
      time = Chronic.parse(phrase.split.last)

      if time
        puts "Parsed: #{phrase} -> #{time.strftime('%I:%M%P')} #{time.zone}"
        times = []
        local_times(time).each do |t|
          times << "#{t.strftime('%I:%M%P')} #{t.zone}"
        end
        message = "> #{times.join(' | ')}"

        h = time.strftime('%I')
        h = h[1] if h.start_with?('0')
        emoji = ":clock#{h}:"
      end
      [message, emoji]
    rescue => e
      p e.message
      [nil, nil]
    end

    # private

    def zone_from_trigger(trigger)
      zone_identifier = trigger[1..99] if trigger[0] == '#'
      puts "ZONE: #{zone_identifier}"
      zone = 'UTC'
      if zone_identifier
        TRIGGER_MAP.keys.each do |key|
          if TRIGGER_MAP[key].include?(zone_identifier)
            zone = key
            break
          end
        end
      end
      zone
    end

    def local_times(time)
      times = []
      TRIGGER_MAP.keys.each do |zone|
        z = TZInfo::Timezone.get(zone)
        times << time.in_time_zone(z)
      end
      times
    end
  end
end
