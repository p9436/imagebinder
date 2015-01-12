module Imagebinder
  class ImagebindersController < ApplicationController
    def create
      object = asset_attributes['assetable_type'].constantize.new
      asset = object.send('build_' << asset_attributes['association_type'], asset_attributes)
      ratio = eval("#{asset.assetable_type}.#{asset.association_type}_ratio")
      if asset.save
        # render :json => { :id => asset.id, :url => crop_imagebinder_url(asset), :crop_ratio => ratio }
        # patch for ie9
        render :text => { :id => asset.id, :url => crop_imagebinder_url(asset, :asset_field => asset_attributes[:asset_field]), :crop_ratio => ratio,  }.to_json
      else
        render :text => asset.error_messages.to_json
      end
    end




    def crop
      @asset = Imgbinder.find_by_id params[:id]
      @asset.asset_field = params[:asset_field]
      render 'imagebinder/crop', :layout => false
    end


    def update
      @asset = Imgbinder.find(params[:id])
      if @asset.update_attributes(asset_attributes)
        @asset.image.reprocess!
        asset_field_name = @asset.asset_field.present? ? @asset.asset_field : @asset.assetable_type.underscore
        render :json => { :id => @asset.id,
                          :image => @asset.image.url(:thumb),
                          :target => asset_field_name.to_s << '_' << @asset.association_type }
      else
        render 'imagebinder/crop', :layout => false
      end
    end

    private

    def asset_attributes
      params.require(:asset).permit(:assetable_type, :association_type, :asset_field, :image, :crop_x, :crop_y, :crop_w, :crop_h)
    end

  end
end
