require 'rack-flash'
class UsersController < ApplicationController
    use Rack::Flash

    get '/tags' do
        @tags = Tag.all.sort_by { |tag| tag.games.count }.reverse
        erb :'tags/index'
    end

end