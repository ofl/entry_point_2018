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

  describe 'points:expire' do
    let!(:user) { create :user }
    let!(:got_point) { create :point, :got, user: user, created_at: created_at }
    let!(:batch_schedule) { create :batch_schedule_point_expiration, user: user, batch_at: 1.day.ago }

    let(:task) { 'points:expire' }

    subject { @rake[task].invoke }

    context 'expired points not exists' do
      let(:created_at) { 89.days.ago }

      it { expect { subject }.not_to change(Point.expired, :count) }
      it { expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1) }
    end

    context 'expired points exists' do
      let(:created_at) { 91.days.ago }

      it { expect { subject }.to change(Point.expired, :count).by(1) }
      it { expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1) }
    end
  end
end
