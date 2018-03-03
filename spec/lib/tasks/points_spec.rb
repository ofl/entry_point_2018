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
    let!(:got_point) { create :point, :got, created_at: created_at }
    let(:task) { 'points:expire' }

    subject { @rake[task].invoke }

    context 'expired points not exists' do
      let(:created_at) { 89.days.ago }

      it { expect { subject }.not_to change(Point, :count) }
    end

    context 'expired points exists' do
      let(:created_at) { 91.days.ago }

      it { expect { subject }.to change(Point, :count).by(1) }
    end
  end
end
