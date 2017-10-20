class ChangeActivation < ActiveRecord::Migration
  def change
    add_column :accounts, :activation_digest, :string
    add_column :accounts, :activated, :boolean, default: false
    add_column :accounts, :activated_at, :datetime
    remove_column :accounts, :confirmed
    remove_column :accounts, :token
  end
end
