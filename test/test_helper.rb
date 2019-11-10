$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'pry'
require "ruby_tcx"
require "minitest/autorun"

module RubyTcx
  class TestConfig
    FIXTURE_DIR = File.expand_path("test/data")
    DEFAULT_FIXTURE_PATH = File.expand_path(File.join(FIXTURE_DIR, 'stwm2019.tcx'))

    def self.load_fixture(file_name)
      RubyTcx::TcxFile.new(file_name: File.expand_path(File.join(FIXTURE_DIR, "#{file_name}.tcx")))
    end
  end
end