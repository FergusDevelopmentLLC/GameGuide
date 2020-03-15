class User < ActiveRecord::Base
    has_secure_password
    has_many :games, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :game_tag_users
    has_many :tags, through: :game_tag_users, dependent: :destroy
end