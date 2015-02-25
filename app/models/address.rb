class Address < ActiveRecord::Base

  validates :street_address, presence: true, allow_blank: false, length: { in: 1..100 }
  validates :city, presence: true, allow_blank: false, length: { in: 1..100 }
  validates :state, presence: true, allow_blank: false, length: { in: 1..100 }
  validates :country, presence: true, allow_blank: false, length: { in: 1..100 }

  validates :apartment, allow_blank: true, length: { in: 1..100 }
  validates :zip, allow_blank: true, length: { in: 1..100 }


end
