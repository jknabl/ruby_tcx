FILES = [
  'version',
  'track_point',
  'activity',
  'lap',
  'base_parser',
  'parser',
  'sax_parser',
  'track_point_parser',
  'lap_parser',
  'tcx_file',
]
FILES.each { |file| require "ruby_tcx/#{file}" }
