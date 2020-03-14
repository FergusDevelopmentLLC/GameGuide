require 'rack-flash'
class TagsController < ApplicationController
    use Rack::Flash

    get '/tags' do
        @tags = Tag.all.sort_by { |tag| tag.games.count }.reverse
        erb :'tags/index'
    end

    get '/tags/:id' do
        @tag = Tag.find(params[:id])
        erb :'tags/show'
    end

end