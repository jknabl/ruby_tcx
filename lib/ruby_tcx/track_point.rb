module RubyTcx
  class TrackPoint
    attr_reader :time, :latitude, :longitude, :altitude_meters, :distance_meters, :heart_rate_bpm, :speed, :run_cadence

    def initialize(time: nil, latitude: nil, longitude: nil, altitude_meters: nil, distance_meters: nil,
                   heart_rate_bpm: nil, speed: nil, run_cadence: nil)
      @time = time
      @latitude = latitude
      @longitude = longitude
      @altitude_meters = altitude_meters
      @distance_meters = distance_meters
      @heart_rate_bpm = heart_rate_bpm
      @speed = speed
      @run_cadence = run_cadence
    end
  end
end