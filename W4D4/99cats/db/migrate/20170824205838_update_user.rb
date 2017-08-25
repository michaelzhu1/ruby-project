class UpdateUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :password_digeat, :password_digest
  end
end
