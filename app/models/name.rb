class Name < ActiveRecord::Base

  validates :first_name, presence: true, allow_blank: false, length: { in: 1..60 }
  validates :last_name, presence: true, allow_blank: false, length: { in: 1..60 }
  validates :middle_name, allow_blank: true, length: { in: 1..60 }
  validates :suffix, allow_blank: true, length: { in: 1..10 }


  def middle_initial
    return "" if middle_name.blank?
    return middle_name[0]
  end

  def safe(field)
    send(field).gsub(/[^A-Za-z]/, '')
  end

end
