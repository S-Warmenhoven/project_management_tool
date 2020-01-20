require 'rails_helper'

RSpec.describe Project, type: :model do
  
  describe "validates" do

    def project
      @project ||= Project.new(
        title: 'Awesome Article',
        description: 'This is just the best article.'
      )
    end
  
    
    it "has a title" do
      p = project
      p.title = nil
      p.valid?
      expect(p.errors).to have_key(:title)
    end
  
    it("should require a unique title") do
      persisted_project = FactoryBot.create(:project)
      project = Project.new(title: persisted_project.title)
      project.valid?
      expect(project.errors.messages).to(have_key(:title))
      expect(project.errors.messages[:title]).to(include('has already been taken'))

    end
    
    it("should have due date not equal to created at date") do
      p = project
      p.due_date = Date.today
      p.valid?
      expect(p.errors.messages).to have_key(:due_date)
    end

    it("should have due date be after created at date") do
      p = project
      p.due_date = "2017-08-08 00:00:00"
      p.valid?
      expect(p.errors.messages).to have_key(:due_date)
    end
    
  end

end