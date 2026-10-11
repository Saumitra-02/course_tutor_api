require 'rails_helper'

RSpec.describe "Api::Courses", type: :request do
  describe "POST /api/courses" do
    let(:valid_params) do
      {
        course: {
          name: "Python",
          description: "Data Science with Python",
          tutors: [
            { name: "Dheeraj", email: "dheeraj@example.com" },
            { name: "Pratik", email: "pratik@example.com" }
          ]
        }
      }
    end
    
    it "creates a course with its tutors" do
      expect {
        post "/api/courses", params: valid_params, as: :json
      }.to change(Course, :count).by(1)
      .and change(Tutor, :count).by(2)

      expect(response).to have_http_status(:created)

      body = response.parsed_body
      expect(body["course"]["name"]).to eq("Python")
      expect(body["course"]["tutors"].length).to eq(2)
    end

    it "returns validation errors for an invalid course" do
      invalid_params = {
        course: {
          name: nil,
          tutors: []
        }
      }

      expect {
        post "/api/courses", params: invalid_params, as: :json
      }.not_to change(Course, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to include(
        "Name can't be blank"
      )
    end

    it "rolls back the course if a tutor is invalid" do
      invalid_params = {
        course: {
          name: "Python",
          tutors: [
            { name: "Dheeraj", email: "invalid-email" }
          ]
        }
      }

     expect {
      post "/api/courses", params: invalid_params, as: :json
    }.to change(Course, :count).by(0)
    .and change(Tutor, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe "GET /api/courses" do
    it "returns all courses with their tutors" do
      course = Course.create!(name: "Python", description: "Learn Python")
      course.tutors.create!(
        name: "Dheeraj",
        email: "dheeraj@example.com"
      )

      get "/api/courses"

      expect(response).to have_http_status(:ok)

      body = response.parsed_body
      expect(body["courses"].length).to eq(1)
      expect(body["courses"][0]["name"]).to eq("Python")
      expect(body["courses"][0]["tutors"][0]["email"]).to eq(
        "dheeraj@example.com"
      )
    end

    it "returns an empty list when no courses exist" do
      get "/api/courses"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["courses"]).to eq([])
    end
  end
end
