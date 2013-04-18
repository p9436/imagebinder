module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        crop_command + super.join(' ').sub(/ -crop \S+/, '')
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      " -crop #{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y} "  if target.cropping?
    end
  end
end
