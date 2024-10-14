# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  app_version            :string
#  avatar_url             :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  device_platform        :string
#  device_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  hr_count               :integer          default(0)
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invited_by_type        :string
#  name                   :string
#  old_role               :integer          default(0), not null
#  phone                  :string
#  policy_confirmed       :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles                  :hstore
#  score                  :integer          default(0), not null
#  sex                    :integer
#  status                 :integer          default("active")
#  surname                :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :integer
#  organization_id        :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

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
