class Tag < ActiveRecord::Base
    
    has_many :game_tag_users
    has_many :games, through: :game_tag_users, dependent: :destroy
    has_many :users, through: :game_tag_users, dependent: :destroy

    validates_presence_of :name

    include Displayable::InstanceMethods
end