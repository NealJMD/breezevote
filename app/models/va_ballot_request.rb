class VaBallotRequest < ActiveRecord::Base
  include Addressable

  validates :ssn_four, format: { with: /\A[0-9]{4}\z/, message: "must be a 4 digit number" }
  validates :reason_code, inclusion: {
    in: %w(1A 1B 1C 1D 1E 1F 2A 2B 2C 3A 3B 4A 5A 6A 6B 6C 6D 7A 8A),
    message: "is not a valid reason code" }
end
