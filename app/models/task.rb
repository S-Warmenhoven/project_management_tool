class Task < ApplicationRecord

    belongs_to :user
    before_save :capitalize_title
    belongs_to :project

    validates(
        :title, 
        presence: true,
        uniqueness: { 
          case_sensitive: false,
          scope: :project
        },
    )

    validates :body, presence: true

    private

    def capitalize_title
        self.title.capitalize!  
    end

end
