class CreateUserAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :user_auths do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :provider, null: false, default: 0
      t.string :uid, null: false
      t.string :access_token
      t.string :access_secret
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end

    add_index :user_auths, %i[provider uid], unique: true
    add_index :user_auths, :confirmation_token, unique: true
  end
end
