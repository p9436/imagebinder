# == Schema Information
# Schema version: 20120926150141
#
# Table name: assets
#
#  id                 :integer(4)      not null, primary key
#  assetable_id       :integer(4)      indexed => [assetable_type]
#  assetable_type     :string(60)      indexed => [assetable_id]
#  image_file_name    :string(255)
#  image_content_type :string(60)
#  image_file_size    :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  association_type   :string(255)
#
module Imagebinder
  class Imgbinder < ActiveRecord::Base

    self.table_name = "imagebinder"

    belongs_to :assetable, :polymorphic => true

    # attr_accessible :assetable_type, :association_type, :asset_field, :image, :crop_x, :crop_y, :crop_w, :crop_h


    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :asset_field

    after_update :reprocess_image, :if => :cropping?

    def cropping?
      !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
    end


    # attr_accessor :_destroy

    def default_asset_style
      { :preview => "500x500>" }
    end

    has_attached_file :image,
                      :hash_secret => "9395e554cfe2f988ddadc1085d636bd18d517d13",
                      :path        => lambda{ |a| ":rails_root/public/system/imagebinder/:id/:style.:extension"},
                      :url         => :path_to_file,
                      :default_url => lambda{ |a| "/assets/default/#{a.instance.assetable_type.to_s.downcase}_#{a.instance.association_type}_:style.png"},
                      :styles      => lambda{ |a| a.instance.assetable_type.constantize.send("#{a.instance.association_type}_styles").merge(a.instance.default_asset_style) },
                      :processors  => [:cropper]



    validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

    def image_geometry(style = :original)
      @geometry ||= {}
      @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
    end


    private

    def reprocess_image
      # image.reprocess!
    end

    def path_to_file
      "/system/imagebinder/:id/:style.:extension"
    end

  end
end
