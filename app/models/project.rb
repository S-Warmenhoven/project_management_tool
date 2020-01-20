class Project < ApplicationRecord

    belongs_to :user
    before_save :capitalize_title
    has_many :tasks, dependent: :destroy
    has_many :discussions, dependent: :destroy

    #Validations
    validates :title, presence: true, uniqueness: { case_sensitive: false }

    validate :due_date_after_creation_date 

    private

    def capitalize_title
        self.title.capitalize!  
    end

    def due_date_after_creation_date
        if due_date.present? && due_date <= Date.today
          errors.add(:due_date, "must be after project creation date")
        end
    end 

end
