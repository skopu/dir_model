module DirModel
  module Model
    module Relations
      extend ActiveSupport::Concern
      included do
        inherited_class_hash :has_one_relationship
      end
      
      # @return [Boolean] returns true, if the instance is a child
      def child?
        !!parent
      end

      # Appends model to the parent and returns it
      #
      # @return [Model] return the child if it is valid, otherwise returns nil
      def append_dir_model(source_path, options={})
        relation_name = self.class.has_one_relationship.keys.first
        related_class = self.class.has_one_relationship.values.first

        related_dir_model = related_class.new(source_path, options.reverse_merge(parent: self))
        
        unless related_dir_model.skip?
          public_send("#{relation_name}=", related_dir_model)
          related_dir_model
        else
          nil
        end
      end
      alias_method :<<, :append_dir_model

      def has_one?
        false
      end
      
      class_methods do
        # Defines a relationship between a dir model
        #
        # @param [Symbol] relation_name the name of the relation
        # @param [DirModel::Import] dir_model_class class of the relation
        def has_one(relation_name, dir_model_class)
          raise "for now, DirModel's has_one may only be called once" if @_has_one_relationship.present?

          relation_name = relation_name.to_sym

          merge_has_one_relationship(relation_name => dir_model_class)
          
          define_method(:has_one?) do
            true
          end
          
          define_method("#{relation_name}=") do |value|
            instance_variable_set("@#{relation_name}", value)
          end

          define_method(relation_name) do
            instance_variable_get("@#{relation_name}")
          end
        end
      end

    end
  end
end
