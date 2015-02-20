class VaBallotRequest < ActiveRecord::Base
  belongs_to :name
  belongs_to :current_address, class_name: :Address
  belongs_to :registered_address, class_name: :Address
end
