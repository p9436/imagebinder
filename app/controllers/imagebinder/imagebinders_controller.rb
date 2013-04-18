module Imagebinder
  class ImagebindersController < ApplicationController
    def create
      object = params[:asset][:assetable_type].constantize.new
      asset = object.send('build_' << params[:asset][:association_type], params[:asset])
      ratio = eval("#{asset.assetable_type}.#{asset.association_type}_ratio")

      if asset.save
        render :json => { :id => asset.id, :url => crop_imagebinder_url(asset), :crop_ratio => ratio }
      else
        render :json => asset.error_messages
      end
    end

    def crop
      @asset = Imgbinder.find params[:id]
      render 'imagebinder/crop', :layout => false
    end


    def update
      @asset = Imgbinder.find(params[:id])
      if @asset.update_attributes(params[:asset])
        @asset.image.reprocess!
        asset_field_name = @asset.asset_field.present? ? @asset.asset_field : @asset.assetable_type.underscore
        render :json => { :id => @asset.id,
                          :image => @asset.image.url(:thumb),
                          :target => asset_field_name.to_s << '_' << @asset.association_type }
      else
        render 'imagebinder/crop', :layout => false
      end
    end

  end
end
