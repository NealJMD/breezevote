class Submission < ActiveRecord::Base

  belongs_to :user
  belongs_to :document, polymorphic: true

  validates :user_id, presence: true
  validates :document_type, presence: true
  validates :document_id, presence: true, uniqueness: { :scope => :document_type }

end
