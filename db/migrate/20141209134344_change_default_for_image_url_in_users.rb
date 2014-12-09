class ChangeDefaultForImageUrlInUsers < ActiveRecord::Migration
  def change
    change_column :users, :image_url, :string, default: "code monkey.png"
  end
end
