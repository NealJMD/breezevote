module Ownable
  extend ActiveSupport::Concern

  included do
    has_one :submission, :as => :document, :inverse_of => :document
    has_one :user, :through => :submission
  end
end
