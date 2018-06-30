class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, comment: '投稿者'
      t.string :title, null: false,          comment: 'タイトル'
      t.text :body, null: false,             comment: '本文'

      t.timestamps
    end
  end
end
