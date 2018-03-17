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
    let!(:user) { create :user }
    let!(:got_point) { create :point, :got, user: user, created_at: created_at }
    let!(:batch_schedule) { create :batch_schedule_point_expiration, user: user, run_on: 1.day.ago }

    let(:task) { 'points:outdate' }

    subject { @rake[task].invoke }

    context 'outdated points not exists' do
      let(:created_at) { 89.days.ago }

      it { expect { subject }.not_to change(Point.outdated, :count) }
      it { expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1) }
    end

    context 'outdated points exists' do
      let(:created_at) { 91.days.ago }

      it { expect { subject }.to change(Point.outdated, :count).by(1) }
      it { expect { subject }.to change(BatchSchedule::PointExpiration, :count).by(-1) }
    end
  end
end
