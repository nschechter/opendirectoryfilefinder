class CreateOpenDirs < ActiveRecord::Migration
  def change
    create_table :open_dirs do |t|
      t.string :url
      t.string :root_url
      t.string :dir_type
      t.string :dir_links
      t.string :file_links
      t.boolean :scraped
    end
  end
end