class BaseParser
  attr_reader :tcx_file

  def initialize(tcx_file)
    @tcx_file = tcx_file
  end
end