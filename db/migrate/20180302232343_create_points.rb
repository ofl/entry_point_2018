class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.references :user
      t.integer :operation_type, null: false,     comment: '(0:獲得,1:使用,2:失効)'
      t.integer :amount, null: false, default: 0, comment: 'ポイント数'

      t.timestamps
    end
  end
end
