class AddImageUrlToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :image_url, :string
  end
end
