module Utils
  extend ActiveSupport::Concern

  def mkdir
    FileUtils.mkdir_p(yield)
  end
end
