class CreateOpenDirs < ActiveRecord::Migration
  def change
    create_table :open_dirs do |t|
      t.string :url
      t.string :root_url
      t.string :dir_type
      t.text :dir_links, array: true, default: []
      t.text :file_links, array: true, default: []
      t.boolean :scraped, default: false
    end
  end
end