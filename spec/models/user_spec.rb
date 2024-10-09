# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:organization) do
    create(:organization) if user_existing_flag
  end

  let(:user_existing_flag) do
    true if user
  end

  describe 'validations' do
    # ... other validation tests
  end

  describe 'status transitions' do
    # ... status transition tests
  end

  describe '#active_for_authentication?' do
    # ... authentication tests
  end

  context 'when user exists' do
    let(:user) { build(:user, organization: organization) }

    describe '#after_confirmation' do
      it 'calls notify_moderators' do
        expect(user).to receive(:notify_moderators)
        user.after_confirmation
      end
    end

    describe '#notify_moderators' do
      let(:worker_double) { class_double("NewVolunteerNotificationWorker").as_stubbed_const }

      it 'enqueues a notification job' do
        expect(worker_double).to receive(:perform_async).with(user.id)
        user.notify_moderators
      end
    end
  end
end