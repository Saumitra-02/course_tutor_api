class Tutor < ApplicationRecord
  belongs_to :course, inverse_of: :tutors

  validates :name, presence: true
  validates :email, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
end
