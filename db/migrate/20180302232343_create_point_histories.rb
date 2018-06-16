class CreatePointHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :point_histories do |t|
      t.references :user
      t.integer :operation_type, null: false,      comment: '(0:獲得,1:使用,2:失効)'
      t.integer :amount, null: false, default: 0,  comment: '増減したポイント数'
      t.integer :total, null: false, default: 0,   comment: '総ポイント数'
      t.integer :version, null: false, default: 0, comment: '衝突防止のためのバージョン'

      t.timestamps
    end

    add_index(:point_histories, %i[user_id version], order: { user_id: :asc, version: :desc })
  end
end
