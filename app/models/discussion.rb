class Discussion < ApplicationRecord
    has_many :comments, dependent: :destroy

    #Validations:
    validates :tile, presence: true
    validates :description, presence: true

end
