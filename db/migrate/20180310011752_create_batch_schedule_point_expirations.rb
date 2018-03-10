class CreateBatchSchedulePointExpirations < ActiveRecord::Migration[5.1]
  def change
    create_table :batch_schedule_point_expirations do |t|
      t.references :user, foreign_key: true
      t.datetime :batch_at

      t.timestamps
    end
  end
end
