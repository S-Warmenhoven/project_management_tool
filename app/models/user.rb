class User < ApplicationRecord

    has_many :projects, dependent: :nullify
    has_many :tasks, dependent: :nullify
    has_many :discussions, dependent: :nullify
    has_many :comments, dependent: :nullify
    
    has_secure_password
    
    validates :email, presence: true, uniqueness: true, 
    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    
    #above is available because we uncommented the bcrypt gem
    validates :first_name, :last_name, presence: true
    
    def full_name
        "#{first_name} #{last_name}".strip
    end

end
