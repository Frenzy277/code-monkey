class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.integer :balance, default: 1
      t.text :about_me
      t.string :image_url

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
