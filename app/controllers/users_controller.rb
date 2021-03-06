class UsersController < ApplicationController
    
    get "/signup" do
        if logged_in?
            flash[:message] = "Please log out in order to sign up with a new account"
            redirect "/"
        else
            erb :'users/new'
        end
    end

    post "/users" do
        @user = User.new(params[:user])
        if @user.valid?
            @user.save
            flash[:message] = "Account created, please login with your credentials"
            redirect "/login"
        else
            erb :'users/new'
        end
    end

    get "/login" do
        if logged_in?
            flash[:message] = "Please log out in order to login with a different account"
            redirect "/"
        else
            erb :'users/login'
        end
    end

    post "/login" do
        @user = User.find_by(:username => params[:user][:username])
        if(@user && @user.authenticate(params[:user][:password]))
            session[:user_id] = @user.id
            redirect "/"
        else
            flash[:error] = "User name or password incorrect"
            redirect "/login"
        end
    end

    get "/logout" do
        session[:user_id] = nil #using session.clear interfered with flash messages being displayed
        redirect "/"
    end

    get "/users/:id" do
        if !logged_in?
            flash[:message] = "You must be logged in to see user profiles."
            redirect "/"
        else
            @user = User.find_by(:id => params[:id])
            erb :'users/show'
        end
    end

    get "/users/:id/edit" do
        @user = User.find_by(:id => params[:id])
        if !logged_in?
            flash[:message] = "You must be logged in to edit your profile."
            redirect "/"
        else
            if !can_edit_user?(@user)
                flash[:message] = "You cannot edit a user profile other than your own."
                redirect "/"
            else
                erb :'users/edit'
            end
        end
    end

    patch "/users/:id" do
        @user = User.find_by(:id => params[:id])
        if logged_in? && can_edit_user?(@user)
            @user.username = params[:user][:username]
            @user.email = params[:user][:email]
            @user.password = params[:user][:password]
            if(@user.valid?)
                @user.save
                session[:user_id] = nil
                flash[:message] = "Profile updated. Please log in again."
                redirect "/login"
            else
                erb :'users/edit'
            end
        else
            flash[:message] = "You cannot edit a user profile other than your own."
            redirect "/"
        end
    end

    delete "/users/:id" do
        @user = User.find_by(:id => params[:id])
        if logged_in? && can_edit_user?(@user)
            @user.destroy
            Tag.all.find_all {|tag| tag.games.empty?}.each {|tag| tag.destroy} #delete any orphaned tags as a result
            session[:user_id] = nil #using session.clear interfered with flash messages being displayed
            flash[:message] = "Account deleted. Please sign up a new account or login."
        else
            flash[:message] = "You must be logged in and owner of the account to delete it."
        end
        redirect "/"
    end

    get "/users" do
        if !logged_in?
            flash[:message] = "You must be logged in to see user profiles."
            redirect "/"
        else
            @users = User.all
            erb :'users/index'
        end
    end
end