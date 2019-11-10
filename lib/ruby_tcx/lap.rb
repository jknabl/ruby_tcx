module RubyTcx
  class Lap
    attr_reader :start_time,
                :total_time_seconds,
                :distance_meters,
                :maximum_speed,
                :calories,
                :average_heart_rate_bpm,
                :maximum_heart_rate_bpm,
                :intensity,
                :cadence,
                :trigger_method,
                :track_points,
                :average_speed,
                :average_run_cadence,
                :maximum_run_cadence

    def initialize(start_time: nil,
                  total_time_seconds: nil,
                   distance_meters: nil,
                   maximum_speed: nil,
                   calories: nil,
                   average_heart_rate_bpm: nil,
                   maximum_heart_rate_bpm: nil,
                   intensity: nil,
                   cadence: nil,
                   trigger_method: nil,
                   track_points: nil,
                   average_speed: nil,
                   average_run_cadence: nil,
                   maximum_run_cadence: nil
                   )
      @start_time = start_time
      @total_time_seconds = total_time_seconds
      @distance_meters = distance_meters
      @maximum_speed = maximum_speed
      @calories = calories
      @average_heart_rate_bpm = average_heart_rate_bpm
      @maximum_heart_rate_bpm = maximum_heart_rate_bpm
      @intensity = intensity
      @cadence = cadence
      @trigger_method = trigger_method
      @track_points = track_points
      @average_speed = average_speed
      @average_run_cadence = average_run_cadence
      @maximum_run_cadence = maximum_run_cadence
    end
  end
end