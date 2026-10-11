class Course < ApplicationRecord
  has_many :tutors, dependent: :destroy, inverse_of: :course

  validates :name, presence: true
end
