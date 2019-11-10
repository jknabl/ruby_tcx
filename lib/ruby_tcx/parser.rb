require 'nokogiri'

module RubyTcx
  class Parser < BaseParser
    attr_reader :document

    def initialize(tcx_file)
      super(tcx_file)
      @document = nokogiri_document_from(path: tcx_file.file_name)
    end

    def parse
      parse_activity(document)
    end

    def namespace_mapping_for(prefix)
      { 'ns' => namespace_for(prefix) }
    end

    private

    def namespace_prefix_mapping
      {
        'ns1' => 'xmlns',
        'ns2' => 'xmlns:ns2',
        'ns3' => 'xmlns:ns3',
        'ns5' => 'xmlns:ns5',
        'xsi' => 'xmlns:xsi'
      }
    end

    def namespace_for(prefix)
      document.namespaces[namespace_prefix_mapping[prefix]]
    end

    def parse_activity(document)
      activity_node = document.at_xpath('//ns:Activity', namespace_mapping_for('ns1'))
      id_node = activity_node.at_xpath('//ns:Id', namespace_mapping_for('ns1'))
      id = Time.new(id_node.inner_html)
      sport = activity_node['Sport']

      lap_nodes = activity_node.xpath('//ns:Lap', namespace_mapping_for('ns1'))
      laps = lap_nodes.map { |node| parse_lap(node) }

      RubyTcx::Activity.new(
        id: id,
        sport: sport,
        laps: laps
      )
    end

    def parse_lap(lap)
      start_time = Time.new(lap['StartTime'])
      total_time_seconds = lap.at_xpath('//ns:TotalTimeSeconds', namespace_mapping_for('ns1')).inner_html.to_f
      distance_meters = lap.at_xpath('//ns:DistanceMeters', namespace_mapping_for('ns1')).inner_html.to_f
      maximum_speed = lap.at_xpath('//xmlns:MaximumSpeed').inner_html.to_f
      calories = lap.at_xpath('//xmlns:Calories').inner_html.to_i
      avg_hr = lap.at_xpath('//xmlns:AverageHeartRateBpm').inner_html.to_i
      max_hr = lap.at_xpath('//xmlns:MaximumHeartRateBpm').inner_html.to_i
      intensity = lap.at_xpath('//xmlns:Intensity').inner_html
      trigger_method = lap.at_xpath('//xmlns:TriggerMethod').inner_html
      avg_speed = lap.at_xpath('//ns:AvgSpeed', namespace_mapping_for('ns3')).inner_html&.to_i
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

    def parse_track_point(track_point_element)
      RubyTcx::TrackPointParser.new(element: track_point_element, parser: self).parse
    end

    def nokogiri_document_from(path:)
      file = File.open(path)
      doc = Nokogiri::XML(file)
      file.close

      doc
    end
  end
end
