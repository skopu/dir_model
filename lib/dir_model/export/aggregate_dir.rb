require 'active_support/hash_with_indifferent_access'

class DirModel::Export::AggregateDir

  attr_reader :export_dir_model_class, :context, :paths

  # @param [Export] export_model export model class
  def initialize(export_dir_model_class, context={})
    @export_dir_model_class = export_dir_model_class
    @context = context.to_h #.symbolize_keys
  end

  # Add a row_model to the
  # @param [] source_model the source model of the export file model
  # @param [Hash] context the extra context given to the instance of the file model
  def append_model(source_model, context={})
    @paths << export_dir_model_class.new(source_model, context.to_h.reverse_merge(self.context)).path
  end
  alias_method :<<, :append_model

  def generate
    @paths ||= []
    yield self
  end
end
