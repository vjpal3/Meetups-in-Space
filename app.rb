require 'sinatra'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user

  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"
  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."
  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.order(:title)

  erb :'meetups/index'
end

get '/meetups/new' do
  if session[:user_id]
    @meetup = Meetup.new

    erb :'meetups/new'
  else
    flash[:notice] = "You must sign in to create a new meetup."
    redirect '/'
  end
end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  @creator = User.find(@meetup.creator_id)

  #members_ids = MeetupParticipant.where("meetup_id=?", @meetup.id).pluck(:user_id)
  members_ids = MeetupParticipant.where("meetup_id=?", @meetup).pluck(:user_id)
  @members = []

  @join_button = true
  members_ids.each do |id|
    if session[:user_id] == id
      @join_button = false
    end
    @members << User.find(id)
  end

  @leave_button = false
  if !@join_button
    @leave_button = true
  end

  @edit_button = false
  @delete_button = false
  if @meetup.creator_id == session[:user_id]
    @edit_button = true
    @delete_button = true
  end

  erb :'meetups/show'
end

get '/meetups/:id/edit' do
  @meetup = Meetup.find(params[:id])
  @creator = User.find(@meetup.creator_id)
  erb :'meetups/update'
end

patch '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  if @meetup.creator_id == session[:user_id]
    if @meetup.update(params[:meetup])
      @creator = User.find(@meetup.creator_id)
      # flash[:notice] = "You have successfully updated the meetup"
      @message = "You have successfully updated the meetup"
      erb :'meetups/show'
    else
      @message = "Update failed"
      @error_msgs = @meetup.errors.full_messages
      erb :'meetups/update'
    end
  else
    redirect '/meetups'
  end
end

delete '/meetups/:id' do
  meetup = Meetup.find(params[:id])
  if meetup.creator_id == session[:user_id]
    #delete the participants first
    members = MeetupParticipant.where("meetup_id=?", meetup)
    members.delete_all
    meetup.delete
  end
  redirect '/meetups'
end

post '/meetups' do
  @meetup = Meetup.new(params[:meetup])
  if @meetup.save
    @creator = User.find(@meetup.creator_id)
    # flash[:notice] = "You have successfully created a meetup"
    @message = "You have successfully created a meetup"
    erb :'meetups/show'
  else
    @error_msgs = @meetup.errors.full_messages
    erb :'meetups/new'
  end
end

post '/meetups/:id/meetup_participants' do
  if session[:user_id].nil?
    flash[:notice] = "You must sign in to join this meetup."
    redirect "/meetups"
  else
    participant = MeetupParticipant.new(meetup_id: params[:id], user_id: session[:user_id])
    if participant.save
      flash[:notice] = "You have successfully joined this meetup."
    end
     redirect "/meetups/#{params[:id]}"
  end
  #redirect "/meetups/#{params[:id]}"
end

delete '/meetups/:id/meetup_participants/:participant_id' do
  # if session[:user_id] == params[:participant_id] //flash doesn't work if this code is present
  if !session[:user_id].nil?
    participant = MeetupParticipant.find_by(meetup_id: params[:id], user_id: params[:participant_id])
    if participant.delete
      flash[:notice] = "You have left the meetup"
    end
  end 
  # end
  redirect "/meetups/#{params[:id]}"

end
