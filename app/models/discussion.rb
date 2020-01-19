class Discussion < ApplicationRecord

    belongs_to :user
    has_many :comments, dependent: :destroy

    #Validations:
    validates :tile, presence: true
    validates :description, presence: true

end
