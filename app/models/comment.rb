class Comment < ApplicationRecord

    belongs_to :user
    belongs_to :discussion

    #Validations
    validates :body, presence: true
end
