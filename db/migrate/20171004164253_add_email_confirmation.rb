class AddEmailConfirmation < ActiveRecord::Migration
  def change
    add_column :accounts, :confirmed, :boolean, :default => false
    add_column :accounts, :token, :string
  end
end
