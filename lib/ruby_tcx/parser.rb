require 'nokogiri'

module RubyTcx
  class Parser < BaseParser
    attr_reader :document

    def parse
      document = nokogiri_document_from(path: tcx_file.file_name)
      parse_activity(document)
    end

    private

    def parse_activity(document)
      activity_node = document.at_xpath('//xmlns:Activity')
      id_node = activity_node.at_xpath('//xmlns:Id')
      id = Time.new(id_node.inner_html)
      sport = activity_node['Sport']

      lap_nodes = activity_node.xpath('//xmlns:Lap')
      laps = lap_nodes.map { |node| parse_lap(node) }

      RubyTcx::Activity.new(
        id: id,
        sport: sport,
        laps: laps
      )
    end

    def parse_lap(lap)
      start_time = Time.new(lap['StartTime'])
      total_time_seconds = lap.at_xpath('//xmlns:TotalTimeSeconds').inner_html.to_f
      distance_meters = lap.at_xpath('//xmlns:DistanceMeters').inner_html.to_f
      maximum_speed = lap.at_xpath('//xmlns:MaximumSpeed').inner_html.to_f
      calories = lap.at_xpath('//xmlns:Calories').inner_html.to_i
      avg_hr = lap.at_xpath('//xmlns:AverageHeartRateBpm').inner_html.to_i
      max_hr = lap.at_xpath('//xmlns:MaximumHeartRateBpm').inner_html.to_i
      intensity = lap.at_xpath('//xmlns:Intensity').inner_html
      trigger_method = lap.at_xpath('//xmlns:TriggerMethod').inner_html
      avg_speed = lap.at_xpath('//ns3:AvgSpeed').inner_html&.to_i
      avg_run_cadence = lap.at_xpath('//ns3:AvgRunCadence').inner_html&.to_i
      max_run_cadence = lap.at_xpath('//ns3:MaxRunCadence').inner_html&.to_i
      track_point_nodes = lap.xpath('//xmlns:Trackpoint')
      track_points = track_point_nodes.map { |node| parse_track_point(node) }

      RubyTcx::Lap.new(
        start_time: start_time,
        total_time_seconds: total_time_seconds,
        distance_meters: distance_meters,
        maximum_speed: maximum_speed,
        calories: calories,
        average_heart_rate_bpm: avg_hr,
        maximum_heart_rate_bpm: max_hr,
        intensity: intensity,
        trigger_method: trigger_method,
        track_points: track_points,
        average_speed: avg_speed,
        average_run_cadence: avg_run_cadence,
        maximum_run_cadence: max_run_cadence
      )
    end

    def parse_track_point(track_point)
      time = Time.new(track_point.at_xpath('//xmlns:Time').inner_html)
      latitude = track_point.at_xpath('//xmlns:LatitudeDegrees').inner_html&.to_f
      longitude = track_point.at_xpath('//xmlns:LongitudeDegrees').inner_html&.to_f
      altitude_meters = track_point.at_xpath('//xmlns:AltitudeMeters').inner_html&.to_i
      distance_meters = track_point.at_xpath('//xmlns:DistanceMeters').inner_html&.to_i
      hr_bpm = track_point.at_xpath('//xmlns:HeartRateBpm').inner_html&.to_i
      speed = track_point.at_xpath('//ns3:Speed').inner_html&.to_f
      cadence = track_point.at_xpath('//ns3:RunCadence').inner_html&.to_i

      RubyTcx::TrackPoint.new(
        time: time,
        latitude: latitude,
        longitude: longitude,
        altitude_meters: altitude_meters,
        distance_meters: distance_meters,
        heart_rate_bpm: hr_bpm,
        speed: speed,
        run_cadence: cadence
      )
    end

    def nokogiri_document_from(path:)
      file = File.open(path)
      doc = Nokogiri::XML(file)
      file.close

      doc
    end
  end
end
