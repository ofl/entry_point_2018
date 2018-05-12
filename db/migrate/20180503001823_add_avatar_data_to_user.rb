class AddAvatarDataToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avatar_data, :text, after: :username, comment: 'アバター画像'
  end
end
