class Name < ActiveRecord::Base

  validates :first_name, format: { with: /\A[^\s]+\z/, message: "cannot be whitespace" }, allow_blank: false
  validates :last_name, format: { with: /\A[^\s]+\z/, message: "cannot be whitespace" }, allow_blank: false
  validates :middle_name, format: { with: /\A[^\s]*\z/, message: "cannot be whitespace" }
  validates :suffix, format: { with: /\A[^\s]*\z/, message: "cannot be whitespace" }


  def middle_initial
    return "" if middle_name.blank?
    return middle_name[0]
  end

end
