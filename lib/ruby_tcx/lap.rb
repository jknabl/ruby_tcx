module RubyTcx
  class Lap
    attr_reader :total_time_seconds,
                :distance_meters,
                :maximum_speed,
                :calories,
                :average_heart_rate_bpm,
                :maximum_heart_rate_bpm,
                :intensity,
                :cadence,
                :trigger_method,
                :track,
                :notes,
                :extensions

    def initialize(total_time_seconds: nil,
                   distance_meters: nil,
                   maximum_speed: nil,
                   calories: nil,
                   average_heart_rate_bpm: nil,
                   maximum_heart_rate_bpm: nil,
                   intensity: nil,
                   cadence: nil,
                   trigger_method: nil,
                   track: nil,
                   notes: nil,
                   extensions: nil
                   )
      @total_time_seconds = total_time_seconds
      @distance_meters = distance_meters
      @maximum_speed = maximum_speed
      @calories = calories
      @average_heart_rate_bpm = average_heart_rate_bpm
      @maximum_heart_rate_bpm = maximum_heart_rate_bpm
      @intensity = intensity
      @cadence = cadence
      @trigger_method = trigger_method
      @track = track
      @notes = notes
      @extensions = extensions
    end


  end
end