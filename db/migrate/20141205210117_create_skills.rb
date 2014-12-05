class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.references :user, index: true
      t.references :language, index: true
      t.string :spec

      t.timestamp
    end
  end
end
