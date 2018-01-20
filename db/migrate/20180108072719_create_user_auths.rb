class CreateUserAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :user_auths do |t|
      t.references :user, foreign_key: true
      t.integer :provider
      t.string :uid
      t.string :access_token
      t.string :access_secret
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps
    end
  end
end
