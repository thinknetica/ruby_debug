# frozen_string_literal: true

module ApiErrors
  class MessageHandler
    CONFIG = {
      9801 => 'some.validation.error',
      9802 => 'create.some.error',
      9803 => 'another.validation.error',
      9804 => 'create.another.error',
      9805 => 'another.code.validation.error',
      9806 => 'create.another.code.error',
      9807 => 'blank.comment.error',
      9808 => 'create.user.error',
      9809 => 'cancel.user.error',
      9810 => 'user.not.found.error',
      9811 => 'create.user.account.error',
      9812 => 'create.user.with.error',
      9813 => 'another.by.uid.not.found.error',
      9814 => 'another.by.id.not.found.error',
      9815 => 'some.by.id.not.found.error',
      9816 => 'another.coordinates.by.id.not.found.error',
      9817 => 'help_request.not.available',
      9818 => 'validate.gt.params.error',
      9819 => 'blank.comment.params.error',
      9898 => 'another.code.by.id.not.found.error',
      9821 => 'another.code.by.id.already.used.error',
      9832 => 'another.coordinates.list.params.empty',
      9834 => 'help_request.disabled.for.account',
      9835 => 'description.matching.error',
      9836 => 'client.user.id.duplicated',
      9837 => 'user.not.found.by.client.user.id.error',
      9838 => 'organization.not.found.by.key.error',
      9700 => 'api.disabled.error',
      9701 => 'api.key.does.not.have.some.role.error',
      9702 => 'api.key.does.not.have.help_request.role.error',
      9704 => 'organization.disabled.error',
      9705 => 'user.does.not.have.another.permissions',
      9706 => 'user.does.not.have.some.permissions',
      9707 => 'user.does.not.have.help_request.permissions',
      401 => 'authorization.failed.error'
    }.freeze

    def self.call(code)
      CONFIG[code].humanize.split('.').join(' ')
    rescue
      'Server error'
    end
  end
end
