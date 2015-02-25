class VaBallotRequest < ActiveRecord::Base
  include Addressable

  validates :ssn_four, numericality: { only_integer: true }, length: { is: 4 }
end
