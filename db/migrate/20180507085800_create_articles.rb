class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.references :user, foreign_key: true, comment: '著者'
      t.string :title, null: false,          comment: 'タイトル'
      t.text :body, null: false,             comment: '本文'
      t.datetime :published_at,              comment: '公開日時'

      t.timestamps
    end
  end
end
