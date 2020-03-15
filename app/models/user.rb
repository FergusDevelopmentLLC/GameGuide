class User < ActiveRecord::Base
    has_secure_password
    has_many :games, dependent: :destroy
    has_many :tags, dependent: :destroy
    has_many :comments, dependent: :destroy
end