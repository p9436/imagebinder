module Imagebinder
  module ImagebinderHelper

    def ctrl_upload object, asset_type, asset_field=nil
      asset_field = asset_field || object.class.to_s.underscore
      link_to('Change', "#" << html_id(asset_field, asset_type),
              :id => "link_to_" << html_id(asset_field,asset_type),
              :class => :'delete-btn'
             )
    end

    def ctrl_remove object, asset_type, asset_field=nil
      asset_field = asset_field || object.class.to_s.underscore
      link_to('Remove', '#', onclick: "if (confirm('Do you really want to do this?')) asset_remove('#{html_id(asset_field, asset_type)}',
                       '/assets#{object.class.to_s.underscore}_#{asset_type}_thumb.png' ); return false",
                       :id => "remove_asset_" << html_id(asset_field,asset_type),
                       :class => :'delete-btn'
                      )
    end

    def bind_image object, form, asset_type, *args
      args = args.first
      field_label = args[:label] || ''
      description = args[:description] || ''
      asset_field = args[:asset_field] || object.class.to_s.underscore
      style       = args[:style] || :thumb

      object.send('build_'<<asset_type.to_s)  if object.send(asset_type).nil?
      r = form.fields_for asset_type do |builder|
        render 'imagebinder/asset_fields', :object => object,
                                           :f => builder,
                                           :asset_type  => asset_type,
                                           :asset_field => asset_field,
                                           :field_label => field_label,
                                           :description => description,
                                           :box_id      => html_id(asset_field, asset_type),
                                           :style       => style
      end
      upload_form = upload_image_form object, asset_type, description, asset_field
      js = javascript_tag <<-jsinitcode
        $(function() {
          $('.asset.#{html_id(asset_field, asset_type)}').closest('form').after("#{escape_javascript(upload_form)}");
          asset_upload_init($('##{html_id(asset_field, asset_type)}'));
          $("#link_to_#{html_id(asset_field, asset_type)}").fancybox({modal:true});
        });
      jsinitcode

      if defined?(ActiveAdmin::Views::FormtasticProxy) && form.is_a?(ActiveAdmin::Views::FormtasticProxy)
        form.inputs class: 'hide' do
          js.html_safe
        end
      else
        r << js
      end

    end



    private


    def html_id asset_field, asset_type
      "#{asset_field}_#{asset_type.to_s}"
    end

    def upload_image_form object, asset_type, description = '', asset_field=''
      render 'imagebinder/upload_asset', :object => object.class.new,
                                         :asset_type => asset_type,
                                         :box_id => html_id(asset_field, asset_type),
                                         :description => description,
                                         :asset_field => asset_field
    end

  end
end
