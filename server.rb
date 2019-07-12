require "sinatra/activerecord"
require "sinatra"
# require "sqlite3"

#establishes connection to the database so SQLite can access it in the first place
# ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database:"./database.sqlite3")
# set :database, {adapter: "sqlite3", database: "./database.sqlite3"}

if ENV['RACK_ENV']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end
enable :sessions #enables cookies

#User inherits ActiveRecord to allow the user to access the information that they made
class User < ActiveRecord::Base
end
class Post < ActiveRecord::Base
end

get "/" do
  erb :home
  # puts "Running"
end

get "/signup" do
  @user = User.new #Useless (aka MUDA MUDA MUDA)
  erb :'users/signup'
end

post '/signup' do
  @user = User.new(params) #allows user to create a User object with the parameters saved in the "create_users.rb" in the migrate folder
  if @user.save #Able to save because user is able to inherit the Active record
    p "#{@user.first_name} was saved to the database"
  end
  erb :'users/thanks'
end

get '/thanks' do
  erb :'users/thanks'
end

get '/login' do
  if session[:user_id] #aka cookies. NOTE: Look up cookies and sessions
    redirect '/'
  else
    erb :'users/login'
  end
end
#Lines 35 to 41: If the user is logged in or signed up, it redirects to the home page with their content
#IF not, it redirects them to login page

post '/login' do
  given_password = params[:password]
  @user = User.find_by(email:params[:email])
  if @user
    if @user.password == given_password
      p "user authenticated successfully"
      session[:user_id] = @user.id # setting the session id to the user id

    else
      p "invalid password"
    end
  end
    redirect '/'
end

get "/user_post" do
  # @post = Post.find_by(content: params[:content])
  @create= Post.all
  erb :"users/user_post"
end

post "/user_post" do
  @post = Post.new(params)
  if @post.save

  end
  redirect '/user_post'
end



post "/delete_user" do
  erb :"users/delete_user"
end
# Delete request
post '/logout' do
  session.clear #Look up sinatra active records methods for clear
  p 'user logged out successfully'
  redirect '/'
end
# MVC

# delete '/login' do
#   session[:user_id] = user.id
#   @user.destroy(session[:user_id])
#   redirect '/logout'
# end
