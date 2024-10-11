# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_destroy :dont_delete_this_shit!

  private

  def dont_delete_this_shit!
    return unless self.class.name.match?(/K.*in.*d/)
    self.class.create!(
      name: "#{self.name}#{self.id}",
      organization: self.organization,
      default: self.default
    )
  end
end
