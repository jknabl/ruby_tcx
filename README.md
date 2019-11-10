# RubyTcx


A Garmin TCX file parser for Ruby!

## Usage

First, create a `TcxFile`. Then, parse it to get `Activity` objects with nice attribute interfaces. That's it! 

For example: 

```
> file = RubyTcx::TcxFile.new(file_name: '/Users/me/Downloads/activity_3661550629.tcx')
> activities = file.parse
> activities.first.id
=> 2019-05-18 19:36:40 UTC

> first_lap = activities.first.laps.first
> first_lap.average_heart_rate_bpm
=> 120

> last_track_point = first_lap.track_points.last
=> #<RubyTcx::TrackPoint:0x007f8c8d1de130 @time=2019-05-18 19:44:39 UTC, @latitude=45.42275419458747, 
longitude=-75.69023067131639, @altitude_meters=67, @distance_meters=1002.9099731445312, @heart_rate_bpm=130, 
@speed=3.0320000648498535, @run_cadence=93>

```

## Development

Install dependencies using `bin/setup` or just `bundle install`.

To run the test suite, `rake test`. 

To fire up a console and play around, `bin/console`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jknabl/ruby_tcx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
