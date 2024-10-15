# frozen_string_literal: true

module ApiErrors
  class Base < StandardError
    attr_reader :status, :message

    def initialize(opts = {})
      @message = MessageHandler.call(opts[:message] || 2000)
      @status  = opts[:status] || 400
    end

    def inspect
      reason += " (#{@reason})" if @reason.present?
      %(#<#{self.class.name}: #{message} #{reason}, status: #{status}>)
    end
  end

  class SomeValidationError < Base
    def initialize
      super(message: 9801, status: 422)
    end
  end

  class CreateSomeError < Base
    def initialize
      super(message: 9802, status: 422)
    end
  end

  class AnotherValidationError < Base
    def initialize
      super(message: 9803, status: 422)
    end
  end

  class CreateAnotherError < Base
    def initialize
      super(message: 9804, status: 422)
    end
  end

  class AnothermessageValidationError < Base
    def initialize
      super(message: 9805, status: 422)
    end
  end

  class CreateAnothermessageError < Base
    def initialize
      super(message: 9806, status: 422)
    end
  end

  class BlankCommentError < Base
    def initialize
      super(message: 9807, status: 422)
    end
  end

  class CreateUserError < Base
    def initialize
      super(message: 9808, status: 422)
    end
  end

  class CancelUserError < Base
    def initialize
      super(message: 9809, status: 422)
    end
  end

  class UserNotFoundError < Base
    def initialize
      super(message: 9810, status: 404)
    end
  end

  class CreateUserAccountError < Base
    def initialize
      super(message: 9811, status: 422)
    end
  end

  class CreateUserWithError < Base
    def initialize
      super(message: 9812, status: 422)
    end
  end

  class AnotherByUidNotFoundError < Base
    def initialize
      super(message: 9813, status: 422)
    end
  end

  class AnotherByIdNotFoundError < Base
    def initialize
      super(message: 9814, status: 422)
    end
  end

  class SomeByIdNotFoundError < Base
    def initialize
      super(message: 9815, status: 422)
    end
  end

  class AnotherCoordinatesByIdNotFoundError < Base
    def initialize
      super(message: 9816, status: 422)
    end
  end

  class HelpRequestNotAvailable < Base
    def initialize
      super(message: 9817, status: 422)
    end
  end

  class ValidateGtParamsError < Base
    def initialize
      super(message: 9818, status: 422)
    end
  end

  class BlankCommentParamsError < Base
    def initialize
      super(message: 9819, status: 422)
    end
  end

  class AnothermessageByIdNotFoundError < Base
    def initialize
      super(message: 9898, status: 422)
    end
  end

  class AnothermessageByIdAlreadyUsedError < Base
    def initialize
      super(message: 9821, status: 422)
    end
  end

  class AnotherCoordinatesListParamsEmpty
    def initialize
      super(message: 9832, status: 422)
    end
  end

  class HelpRequestDisabledForAccountError < Base
    def initialize
      super(message: 9834, status: 422)
    end
  end

  class DescriptionMatchingError < Base
    def initialize
      super(message: 9835, status: 422)
    end
  end

  class ClientUserIdDuplicated
    def initialize
      super(message: 9836, status: 422)
    end
  end

  class UserNotFoundByClientUserIdError < Base
    def initialize
      super(message: 9837, status: 422)
    end
  end

  class OrganizationNotFoundByKeyError < Base
    def initialize
      super(message: 9838, status: 422)
    end
  end

  class ApiDisabledError < Base
    def initialize
      super(message: 9700, status: 422)
    end
  end

  class ApiKeyDoesNotHaveSomeRoleError < Base
    def initialize
      super(message: 9701, status: 422)
    end
  end

  class ApiKeyDoesNotHaveHelpRequestRoleError < Base
    def initialize
      super(message: 9702, status: 422)
    end
  end

  class OrganizationDisabledError < Base
    def initialize
      super(message: 9704, status: 422)
    end
  end

  class UserDoesNotHaveAnotherPermissions < Base
    def initialize
      super(message: 9705, status: 403)
    end
  end

  class UserDoesNotHaveSomePermissions
    def initialize
      super(message: 9706, status: 406)
    end
  end

  class UserDoesNotHaveHelpRequestPermissionsError < Base
    def initialize
      super(message: 9707, status: 422)
    end
  end

  class AuthorizationFailedError < Base
    def initialize
      super(message: 401, status: 422)
    end
  end

  class ServerApiError < StandardError
    def initialize(message)
      super(message: message, status: 500)
    end
  end
end
