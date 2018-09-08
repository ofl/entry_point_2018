require 'rails_helper'
require 'rake'

describe 'rake task points' do # rubocop:disable Rspec/DescribeClass
  # rubocop:disable Rspec/InstanceVariable

  before(:all) do # rubocop:disable Rspec/BeforeAfterAll
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/points'
    Rake::Task.define_task(:environment)
  end

  before do
    @rake[task].reenable
  end

  describe 'points:outdate' do
    subject { @rake[task].invoke }

    let(:now) { '2018-4-2 19:10:51'.in_time_zone }
    let!(:user) { create :user }
    let(:task) { 'points:outdate' }

    before do
      Timecop.freeze(now)
      create :point_history, :got, user: user, created_at: created_at
      create :batch_schedule_point_expiration, user: user, run_at: now.yesterday.end_of_day
    end

    after { Timecop.return }

    context '期限切れのポイントが存在する場合' do
      let(:created_at) { '2018-1-1 23:59:59'.in_time_zone }

      it '期限切れのポイント履歴が増えること' do
        expect { subject }.to change(PointHistory.outdated, :count).by(1)
      end
      it 'BatchSchedule::PointExpirationが減ること' do
        expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1)
      end
    end

    context '期限切れのポイントが存在しない場合' do
      let(:created_at) { '2018-1-2 00:00:00'.in_time_zone }

      it '期限切れのポイント履歴が増えないこと' do
        expect { subject }.not_to change(PointHistory.outdated, :count)
      end
      it 'BatchSchedule::PointExpirationが減ること' do
        expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1)
      end
    end
  end

  # rubocop:enable Rspec/InstanceVariable
end
