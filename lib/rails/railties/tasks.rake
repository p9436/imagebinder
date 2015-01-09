namespace :imagebinder do
  
  desc "example gem rake task"
  task :report => :environment do
    puts "you just ran the example gem rake task"
    # Imagebinder::Imgbinder.where(assetable_id:nil).where('updated_at < ?', Time.now-30.days).size
  end

end
