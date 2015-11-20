Bundler.require(:default, :test)

require 'pry'

require 'dir_model'

Dir[Dir.pwd + '/spec/fixtures/**/*.rb'].each { |f| require f }
Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }
