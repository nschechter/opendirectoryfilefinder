class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.string :url
      t.string :root_url
      t.string :type
      t.string :dir_links
      t.string :file_links
      t.boolean :scraped
    end
  end
end