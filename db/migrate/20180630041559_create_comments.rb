class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, comment: '投稿者'
      t.references :post, foreign_key: true, comment: '投稿'
      t.text :body, null: false,             comment: '本文'

      t.timestamps
    end
  end
end
