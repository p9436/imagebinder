module Imgbinder
  module ActsAsImagebinder
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods

      def acts_as_imagebinder association_name, *args


        has_one association_name, -> { where association_type: association_name},
                as: :assetable,
                dependent: :destroy,
                class_name: 'Imagebinder::Imgbinder'

        accepts_nested_attributes_for association_name, :allow_destroy => true

        define_method association_name.to_s do
          super().nil? ? eval("build_#{association_name}") : super()
        end

        args = args.first || {}
        define_singleton_method "#{association_name.to_s}_styles" do
          args[:styles] || {}
        end

        define_singleton_method "#{association_name.to_s}_ratio" do
          args[:ratio]
        end

        define_method "#{association_name.to_s}_attributes=" do |params|
          if [1, '1', true, 'true'].include? params['_destroy']
            self.cover = nil
          else
            eval("self.#{association_name} = Imagebinder::Imgbinder.find_by_id(params['id'])")
          end
        end

      end

    end




    ActiveRecord::Base.send :include, Imgbinder::ActsAsImagebinder

  end
end
