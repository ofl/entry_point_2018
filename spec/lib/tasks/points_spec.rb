require 'rails_helper'
require 'rake'

describe 'rake task points' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/points'
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @rake[task].reenable
  end

  describe 'points:outdate' do
    before { Timecop.freeze(now) }
    after { Timecop.return }

    let(:now) { '2018-4-2 19:10:51'.in_time_zone }

    let!(:user) { create :user }
    let!(:got_point) { create :point, :got, user: user, created_at: created_at }
    let!(:batch_schedule) { create :batch_schedule_point_expiration, user: user, run_at: now.yesterday.end_of_day }

    let(:task) { 'points:outdate' }

    subject { @rake[task].invoke }

    context '期限切れのポイントが存在する場合' do
      let(:created_at) { '2018-1-1 23:59:59'.in_time_zone }

      it '期限切れのポイント履歴が増えること' do
        expect { subject }.to change(Point.outdated, :count).by(1)
      end
      it 'BatchSchedule::PointExpirationが減ること' do
        expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1)
      end
    end

    context '期限切れのポイントが存在しない場合' do
      let(:created_at) { '2018-1-2 00:00:00'.in_time_zone }

      it '期限切れのポイント履歴が増えないこと' do
        expect { subject }.not_to change(Point.outdated, :count)
      end
      it 'BatchSchedule::PointExpirationが減ること' do
        expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1)
      end
    end
  end
end
