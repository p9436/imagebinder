require "imagebinder/version"

module Imagebinder
  # require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'imagebinder/engine'
  require 'imagebinder/acts_as_imagebinder'
  require 'paperclip_processors/cropper'
end
