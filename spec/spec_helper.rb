Bundler.require(:default, :test)

require 'pry'

require 'dir_model'

require Dir.pwd + '/spec/fixtures/models/image_dir.rb'
require Dir.pwd + '/spec/fixtures/models/image_export_dir.rb'
require Dir.pwd + '/spec/fixtures/models/image_import_dir.rb'

require Dir.pwd + '/spec/fixtures/models/models.rb'

# Dir[Dir.pwd + '/spec/fixtures/**/*.rb'].each { |f| require f }
Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }
