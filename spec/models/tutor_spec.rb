require 'rails_helper'

RSpec.describe Tutor, type: :model do
  # create a course for tests that need a tutor to belong to one
  let (:course) { Course.create!(name: "Python") }

  # shared valid attributes
  let (:valid_attributes) do
    {
      name: "Dheeraj",
      email: "dheeraj@example.com",
      course: course
    }
  end

  describe "validations" do
    it "is valid with a name, a valid email, and course" do
      tutor = Tutor.new(valid_attributes)
      expect(tutor).to be_valid
    end

    it "is invalid without a name" do
      tutor = Tutor.new(valid_attributes.merge(name: nil))
      expect(tutor).not_to be_valid
      expect(tutor.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email" do
      tutor = Tutor.new(valid_attributes.merge(email: nil))
      expect(tutor).not_to be_valid
      expect(tutor.errors[:email]).to include("can't be blank")
    end

    it "is invalid with an incorrectly formatted email" do
      tutor = Tutor.new(valid_attributes.merge(email: "not-an-email"))

      expect(tutor).not_to be_valid
      expect(tutor.errors[:email]).to include("is invalid")
    end

    it "requires email addresses to be unique regardless of case" do
      Tutor.create!(valid_attributes)

      duplicate_tutor = Tutor.new(
        valid_attributes.merge(email: 'DHEERAJ@example.com')
      )

      expect(duplicate_tutor).not_to be_valid
      expect(duplicate_tutor.errors[:email]).to include("has already been taken")
    end

    it "is invalid without a course" do
      tutor = Tutor.new(valid_attributes.merge(course: nil))
      expect(tutor).not_to be_valid
      expect(tutor.errors[:course]).to include("must exist")
    end
  end

  describe "associations" do
    it "belongs to a course" do
      tutor = Tutor.create!(valid_attributes)
      expect(tutor.course).to eq(course)
    end
  end
end
