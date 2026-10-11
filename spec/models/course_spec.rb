require 'rails_helper'

RSpec.describe Course, type: :model do
  # check that a course can be created with a valid name
  describe "validations" do
    it "is valid with a name" do
      course = Course.new(name: "Python")
      expect(course).to be_valid
    end

    # the Course model validates that a name is present
    it "is not valid without a name" do
      course = Course.new(name: nil)
      expect(course).not_to be_valid
      expect(course.errors[:name]).to include("can't be blank")
    end
  end

  describe "associations" do
    # A course has many tutors
    it "has many tutors" do
      course = Course.create!(name: "Python")

      tutor1 = course.tutors.create!(
        name: "Dheeraj",
        email: "dheeraj@example.com"
      )

      tutor2 = course.tutors.create!(
        name: "Pratik",
        email: "pratik@example.com"
      )

      expect(course.tutors).to contain_exactly(tutor1, tutor2)
    end

    # the model uses dependent: :destroy
    # deleting a course should delete the associated tutors
    it "destroys its tutors when the course is destroyed" do
      course = Course.create!(name: "Python")

      tutor = course.tutors.create!(
        name: "Dheeraj",
        email: "dheeraj@example.com"
      )

      expect {
        course.destroy
      }.to change(Tutor, :count).by(-1)
      
      expect(Tutor.exists?(tutor.id)).to be(false)
    end
  end
end
