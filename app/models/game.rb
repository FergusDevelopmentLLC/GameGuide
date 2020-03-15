class Game < ActiveRecord::Base
    belongs_to :user
    belongs_to :type
    has_many :comments, dependent: :destroy
    has_many :game_tag_users, dependent: :destroy
    has_many :tags, through: :game_tag_users, dependent: :destroy

    def tag_links
        if(self.tags.empty?)
            "This game has no tags yet."
        else
            self.tags.map {|tag| "<a href='/tags/#{tag.id}'>#{tag.name}</a>"}.join(", ")
        end
    end
    
end

