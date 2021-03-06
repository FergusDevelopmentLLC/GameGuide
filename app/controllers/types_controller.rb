class TypesController < ApplicationController
    
    get '/types' do
        @types = Type.all.sort_by { |type| type.games.count }.reverse
        erb :'types/index'
    end

    get '/types/:id' do
        @type = Type.find(params[:id])
        erb :'types/show'
    end

end