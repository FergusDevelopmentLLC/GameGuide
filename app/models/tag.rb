class Tag < ActiveRecord::Base
    belongs_to :user
    has_many :game_tags
    has_many :games, through: :game_tags, dependent: :destroy

    include Displayable::InstanceMethods
end