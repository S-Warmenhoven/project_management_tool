class Discussion < ApplicationRecord

    belongs_to :user
    belongs_to :project
    has_many :comments, dependent: :destroy

    #Validations:
    validates :title, presence: true
    validates :description, presence: true

end
