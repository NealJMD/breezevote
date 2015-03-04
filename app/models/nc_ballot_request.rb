class NcBallotRequest < ActiveRecord::Base
  include Addressable

  validates :ssn_four, format: { with: /\A[0-9]{4}\z/, message: "must be a 4 digit number" }, allow_blank: true
  validates :birthdate, presence: true, allow_blank: false
  validates :date_moved, presence: true, allow_blank: false, :if => :moved_recently?
end
