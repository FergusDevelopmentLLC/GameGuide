class User < ActiveRecord::Base
    has_secure_password
    has_many :games, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :game_tag_users, dependent: :destroy
    has_many :tags, through: :game_tag_users

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates_format_of :email, :with => /\w+@\w+\.\w+/
end