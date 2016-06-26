require 'chronic'
require 'active_support/core_ext/time'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/string'

module TimeBot
  class Calculator
    TRIGGER_MAP = {
      p: 'US/Pacific',
      m: 'US/Mountain',
      c: 'US/Central',
      e: 'US/Eastern',
      co: 'America/Bogota',
      b: 'Europe/London',
      utc: 'UTC',
      ce: 'Europe/Madrid',
      nz: 'Pacific/Auckland'
    }.freeze

    def time_in_zones(phrase)
      return [nil, nil] if phrase.blank?

      zone = zone_from_trigger(phrase.split.first.try(:downcase))
      source_time = (phrase.split.length > 1 ? phrase.split.last : nil)
      time = time_in_source_zone(zone, source_time)

      formatted_response(time)
    rescue => e
      p e.message
      [nil, nil]
    end

    private

    def zone_from_trigger(trigger)
      zone_identifier = trigger[1..99] if trigger[0] == '#'
      # puts "ZONE: #{zone_identifier}"
      available_zones[zone_identifier.try(:to_sym)]
    end

    def time_in_source_zone(zone, time_string)
      return nil unless zone

      Time.zone = zone
      Chronic.time_class = Time.zone
      Chronic.parse(time_string || Time.zone.now.strftime('%I:%M%P'))
    end

    def formatted_response(time)
      return [nil, nil] unless time

      ["> #{local_times(time).join(' | ')}", emoji(time)]
    end

    def local_times(time)
      available_zones.values.each_with_object([]) do |zone, times|
        z = TZInfo::Timezone.get(zone)
        t = time.in_time_zone(z)
        times << "#{t.strftime('%I:%M%P')} #{t.zone}"
      end
    end

    def emoji(time)
      h = time.strftime('%I')
      h = h[1] if h.start_with?('0')
      ":clock#{h}:"
    end

    # Limit returned zones to those in the TIMELORD_ZONES env var.
    # eg. TIMELORD_ZONES=p,m,c,e,co,ce,nz
    def available_zones
      @available_zones ||= (
        zones = ENV['TIMELORD_ZONES'].try(:split, ',')
        zones ||= TRIGGER_MAP.keys
        TRIGGER_MAP.slice(*zones.map(&:to_sym))
      )
    end
  end
end
