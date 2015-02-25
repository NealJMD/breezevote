module Addressable
  extend ActiveSupport::Concern

  included do
    belongs_to :name
    belongs_to :current_address, class_name: :Address
    belongs_to :registered_address, class_name: :Address

    accepts_nested_attributes_for :name, :current_address, :registered_address

    validates :name, presence: true
    validates :current_address, presence: true
    validates :registered_address, presence: true
  end

  module ClassMethods
  end
end
