class Game < ActiveRecord::Base
    belongs_to :user
    belongs_to :type
    has_many :comments
    has_many :game_tags
    has_many :tags, through: :game_tags

    def tag_links
        if(self.tags.empty?)
            "No tags yet"
        else
            self.tags.map {|tag| "<a href='/tags/#{tag.id}'>#{tag.name}</a>"}.join(", ")
        end
    end
    
end

