module Displayable
    module InstanceMethods

        def game_count_display
            if self.games.count == 0
                "No games"
            elsif self.games.count == 1
                "1 game"
            else
                "#{self.games.count.to_s} games"
            end
        end
        
    end
end