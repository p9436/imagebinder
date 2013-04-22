ActiveRecord::Schema.define(:version => 0) do

    create_table :imagebinder, :force => true do |t|
      t.integer  :assetable_id
      t.string   :assetable_type, :limit => 80
      t.string   :association_type, :limit => 80
      t.string   :image_file_name
      t.string   :image_content_type, :limit => 80
      t.integer  :image_file_size
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :imagebinder, [:assetable_id, :assetable_type]

end
