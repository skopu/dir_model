Bundler.require(:default, :test)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dir_model'

Dir[Dir.pwd + '/spec/fixtures/**/*.rb'].each { |f| require f }
Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }
