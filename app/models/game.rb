class Game < ActiveRecord::Base
    belongs_to :user
    belongs_to :type
    has_many :comments, dependent: :destroy
    has_many :game_tag_users, dependent: :destroy
    has_many :tags, through: :game_tag_users, dependent: :destroy

    validates_presence_of :name
    validates_presence_of :short_description
    validates_presence_of :description
    validates_presence_of :type
    validates_presence_of :image

    def tag_links
        if(self.tags.empty?)
            "This game has no tags yet."
        else
            self.tags.map {|tag| "<a href='/tags/#{tag.id}'>#{tag.name}</a>"}.join(", ")
        end
    end

    def self.delete_old_featured
        current_featured_games = Game.where(:featured => 1)
        latest_featured = []
        if current_featured_games.count > 2
            latest_featured << current_featured_games.order(updated_at: :desc).first
            latest_featured << current_featured_games.order(updated_at: :desc).second
            
            current_featured_games.each { |game|
                if(!latest_featured.include?(game))
                    game.featured = 0
                    game.save
                end
            }
        end
    end

    def self.get_featured_except(excluded)
        featured = Game.where(:featured => 1).order(updated_at: :desc) #get all the current featured

        if featured.include?(excluded) || featured.count < 2 #if the featured count < 2, or featured includes the excluded
            filtered = featured.reject { |game| game == excluded } #remove the excluded
            while filtered.count < 2 #add random games until we have 2
                sample = Game.all.sample
                if !filtered.include?(sample) && sample != excluded
                    filtered << sample
                end
            end
            featured = filtered
        end
        featured
    end
    
end

