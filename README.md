# Imagebinder

----
##Instalation

add required gems to Gemfile

    gem 'fancybox2-rails', '~> 0.2.8'
    gem 'jquery-fileupload-rails'
    gem 'paperclip', '~> 4.2'
    gem 'imagebinder', git: 'git@github.com:p9436/imagebinder.git'

application.js

    //= require imagebinder

application.css.scss

     *= require imagebinder

...and don't forget about

     $ rails generate imagebinder

     
----     
## usage

in class

    class Brand < ActiveRecord::Base
      acts_as_imagebinder :picture, :styles => { :thumb => "110x110#", :small => "64x64#" }, ratio: false    # free ratio for crop
      acts_as_imagebinder :picture, :styles => { :thumb => "640x480#", :small => "64x64#" }, ratio: 4/3.to_f # crop for 4x3 ratio
    end

in view
    
    bind_image f.object, f, :picture, label: false


----
## Integration with [activeadmin](http://activeadmin.info/docs/0-installation.html)

add to config/initializers/active_admin.rb

    config.register_javascript 'imagebinder.js'
    config.register_stylesheet 'imagebinder.css'

and usage the same 

     bind_image f.object, f, :picture, label: false
