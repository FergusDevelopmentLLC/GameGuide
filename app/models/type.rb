class Type < ActiveRecord::Base
    has_many :games

    include Displayable::InstanceMethods
end