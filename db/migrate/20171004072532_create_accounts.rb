class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :birthdate
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
