module Ownable
  extend ActiveSupport::Concern

  included do
    has_one :submission, :as => :document, :inverse_of => :document
    has_one :user, :through => :submission

    def state
      self.class.name[0..1].upcase
    end

    def purpose
      self.class.name[2..-1].underscore.split('_').join(' ')
    end

    def symbol
      self.class.name.underscore.to_sym
    end
  end
end
