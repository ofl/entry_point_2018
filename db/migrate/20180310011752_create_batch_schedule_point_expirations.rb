class CreateBatchSchedulePointExpirations < ActiveRecord::Migration[5.1]
  def change
    create_table :batch_schedule_point_expirations do |t|
      t.references :user, foreign_key: true
      t.date :run_on, null: false, comment: 'バッチ実施日(ポイント失効日)'

      t.timestamps
    end

    add_index :batch_schedule_point_expirations, :run_on
  end
end
