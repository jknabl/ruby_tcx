module RubyTcx
  class Activity
    attr_reader :id, :laps, :sport, :creator

    def initialize(id:, laps:, sport:, creator: nil)
      @id = id
      @laps = laps
      @sport = sport
      @creator = creator
    end
  end
end