module ActsAsImagebinder
  module ClassMethods

    def acts_as_imagebinder association_name, *args

      has_one association_name,
              :as => :assetable,
              :dependent => :destroy,
              :class_name => 'Imgbinder',
              :conditions => {:association_type => association_name}

      accepts_nested_attributes_for association_name, :allow_destroy => true

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
          eval("self.#{association_name} = Imgbinder.find_by_id(params['id'])")
        end
      end

    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end
