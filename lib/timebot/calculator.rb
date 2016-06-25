require 'chronic'
require 'active_support/core_ext/time'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/string'

module TimeBot
  class Calculator
    TRIGGER_MAP = {
      'US/Pacific' => %w(PDT PST PACIFIC P #P),
      'US/Mountain' => %w(MDT MST MOUNTAIN M #M),
      'US/Central' => %w(CDT CST CENTRAL C #C),
      'US/Eastern' => %w(EDT EST EASTERN E #E),
      'Europe/London' => %w(BST B #B L LONDON),
      'Europe/Madrid' => %w(CEST CE #CE)
    }.freeze

    def do_times(phrase)
      return [nil, nil] if phrase.blank?

      message = nil
      emoji = nil

      zone_identifier = phrase.split.first.try(:upcase)
      zone_identifier = zone_identifier[1..99] if zone_identifier[0] == '#'
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

      Time.zone = zone
      Chronic.time_class = Time.zone
      time = Chronic.parse(phrase.split.last)

      if time
        puts "Parsed: #{phrase} -> #{time.strftime('%I:%M%P')} #{time.zone}"
        times = []
        TRIGGER_MAP.keys.each do |zone|
          z = TZInfo::Timezone.get(zone)
          local_time = time.in_time_zone(z)
          times << "#{local_time.strftime('%I:%M%P')} #{local_time.zone}"
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
  end
end
