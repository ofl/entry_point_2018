class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.references :user, foreign_key: true
      t.integer :status, null: false,             comment: '状態(獲得/使用/失効)'
      t.integer :amount, null: false, default: 0, comment: 'ポイント数'

      t.timestamps
    end
  end
end
