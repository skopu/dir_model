Bundler.require(:default, :test)

require 'pry'

require 'dir_model'

# Need to be loaded with order
require Dir.pwd + '/spec/fixtures/models/basic_dir_models.rb'
require Dir.pwd + '/spec/fixtures/models/complex_dir_models.rb'
require Dir.pwd + '/spec/fixtures/models/models.rb'

# Dir[Dir.pwd + '/spec/fixtures/**/*.rb'].each { |f| require f }
Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }
