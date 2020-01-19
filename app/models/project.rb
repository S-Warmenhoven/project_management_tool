class Project < ApplicationRecord

    belongs_to :user
    before_save :capitalize_title
    has_many :tasks, dependent: :destroy
    has_many :discussions, dependent: :destroy

    #Validations
    validates :title, presence: true, uniqueness: { case_sensitive: false }

    private

    def capitalize_title
        self.title.capitalize!  
    end

end
