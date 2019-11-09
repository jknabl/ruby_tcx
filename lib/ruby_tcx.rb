FILES = [
  'version',
  'activity',
  'lap',
  'base_parser',
  'parser',
  'sax_parser',
  'tcx_file',
]
FILES.each { |file| require "ruby_tcx/#{file}" }
