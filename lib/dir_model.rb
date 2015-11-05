require 'dir_model/version'

require 'active_support/concern'

require 'dir_model/utils'

require 'dir_model/core_ext/dir'
require 'dir_model/core_ext/zip_dir/zipper'

require 'dir_model/export'
require 'dir_model/export/aggregate_dir'

require 'inherited_class_var'

module DirModel
  extend ActiveSupport::Concern

  included do
    include Utils
    include InheritedClassVar
    inherited_class_hash :files
  end

  module ClassMethods

    # @return [Array<Symbol>] file names
    def file_names
      files.keys
    end

    protected

    def file(file_name, options={})
      merge_files(file_name.to_sym => options)
    end
  end
end
