module Api
  class CoursesController < ApplicationController
    # GET /api/courses
    def index
      # includes eager loads the tutors' data, avoiding N + 1 queries
      courses = Course.includes(:tutors).order(:id)

      # loop over the courses
      # course_json function returns the courses' data in the expected format
      # return the json and status 200 
      render json: {
        courses: courses.map { | course | course_json(course) }
      }, status: :ok
    end

    # POST /api/courses 
    # Creates a course and all its supplied tutors in one transaction. 
    # Example request:  
    # { 
    #   "course": { 
    #     "name": "Ruby on Rails", 
    #     "description": "Learn Rails", 
    #     "tutors": [ { "name": "Saumitra", "email": "saumitra@example.com" } ]
    #    }
    #  }
    def create
      # course_params performs the strong param check
      attributes = course_params

      # we delete the tutor's attiributes from attributes because
      # the course needs to be created first
      # delete will return the tutor related attributes, which we store in
      # tutor_attributes for later use
      tutor_attributes = attributes.delete(:tutors) || []

      course = nil
      Course.transaction do
        # The ! ensures validation errors are reported
        course = Course.create!(
          attributes.to_h
        )

        # loop over tutor_attributes
        # create the tutors associated with this course. 
        # Creating them this way ensures the foreign key course_id is set
        tutor_attributes.each do |tutor_attribute|
          course.tutors.create!(tutor_attribute.to_h)
        end
      end

      # if execution reaches this point, the transaction completed.
      # course_json returns the data required for sending the response
      # for POST /api/courses in the expected format
      render json: {
        course: course_json(course)
      }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: {
        errors: e.record.errors.full_messages
      }, status: :unprocessable_entity
    end 

    private

    # strong params
    def course_params
      params.require(:course).permit(
        :name,
        :description,
        tutors: [ :name, :email ]
      )
    end

    # returns the data required for sending the response
    # for POST /api/courses in the expected format
    def course_json(course)
      {
        name: course.name,
        description: course.description,
        tutors: course.tutors.map do |tutor|
          {
            name: tutor.name,
            email: tutor.email  
          }
        end
      }
    end  
  end
end
