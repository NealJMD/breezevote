class Address < ActiveRecord::Base

  validates :street_address, presence: true, allow_blank: false, length: { in: 1..100 }
  validates :city, presence: true, allow_blank: false, length: { in: 1..100 }
  validates :country, presence: true, allow_blank: false, length: { in: 1..100 }
  validates :state, inclusion: { in: STATE_CODES, message: "must be a valid two letter state code" }, :unless => :is_abroad?

  validates :apartment, allow_blank: true, length: { in: 1..100 }
  validates :zip, allow_blank: true, length: { in: 1..100 }

  before_validation :standardize_state
  before_validation :standardize_usa

  STANDARD_USA = "USA"

  def standardize_state
    return if state.blank?
    scrubbed = state.strip.gsub(/[^A-Za-z ]/, '')
    if scrubbed.length == 2
      self.state = scrubbed.upcase
    else 
      pretty = scrubbed.downcase.titleize
      if STATE_HASH.include? pretty
        self.state = STATE_HASH[pretty]
      end
    end
  end

  def standardize_usa
    acceptable = ["united states of america", "united states", "america", "usa", "us"]
    if country.present? and acceptable.include? country.downcase.strip.gsub(/[^a-z ]/, '')
      self.country = STANDARD_USA
    end
  end

  def is_abroad?
    country != STANDARD_USA
  end

end
