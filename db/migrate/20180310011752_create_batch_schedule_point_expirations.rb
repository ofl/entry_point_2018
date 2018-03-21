class CreateBatchSchedulePointExpirations < ActiveRecord::Migration[5.1]
  def change
    create_table :batch_schedule_point_expirations do |t|
      t.references :user, foreign_key: true
      t.datetime :run_at, null: false, comment: 'バッチ実施日時(ポイント失効日時)'

      t.timestamps
    end

    add_index :batch_schedule_point_expirations, :run_at
  end
end
