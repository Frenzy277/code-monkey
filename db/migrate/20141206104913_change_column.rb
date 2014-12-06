class ChangeColumn < ActiveRecord::Migration
  def change
    remove_column :skills, :spec, :string
    add_column :skills, :description, :text
  end
end
