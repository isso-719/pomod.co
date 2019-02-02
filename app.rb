require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'

require 'date'
require 'time'

# require 'kaminari'
require 'sinatra'
require 'padrino-helpers'
require 'kaminari/sinatra'

enable :sessions

helpers Kaminari::Helpers::SinatraHelpers

helpers do

  def current_user
    User.find_by(id: session[:user])
  end

  def now_date
    Date.today
  end

end

get '/' do

  erb :index
end

before '/login' do

    if session[:user]
    redirect '/login'
  end

end

get '/login' do

  erb :login
end

post '/login' do

  user = User.find_by(mail: params[:mail])
  if user && user.authenticate(params[:password])
    session[:user] = user.id

  else
    redirect'/login'

  end

  redirect '/'
end

before '/logout' do

    unless session[:user]
    redirect '/login'
  end

end

get '/logout' do

  session[:user] = nil

  redirect '/'
end

before '/signup' do

    if session[:user]
    redirect '/login'
  end

end

get '/signup' do

  erb :signup
end

post '/signup' do
  @user = User.create(name:params[:name],mail:params[:mail],password:params[:password],password_confirmation:params[:password_confirmation])

  if @user.persisted?
    session[:user] = @user.id

    redirect '/'
  else
    redirect '/signup'
  end


end

before '/history' do

  unless session[:user]
    redirect '/login'
  end

end

get '/history' do

  @tomatoes = Kaminari.paginate_array(current_user.tomatoes.where.not(tomato_start_datetime: "", tomato_end_datetime: "")).page(params[:page]).per(5)

  erb :history
end

# before '/timer' do

#     if session[:user]
#     redirect '/timer'
#   end

# end

get '/timer' do

  erb :timer
end

before '/account' do

  unless session[:user]
    redirect '/login'
  end

end

get '/account' do

  user = User.find_by(id: session[:user])


  erb :account
end

post '/account/timer/timer' do

  user = User.find_by(id: session[:user])
  user.user_timer_mode = "timer"
  user.save

  redirect '/account'

end

post '/account/timer/tomato' do

  user = User.find_by(id: session[:user])
  user.user_timer_mode = "tomato"
  user.save

  redirect '/account'

end

post '/account/update/general' do

  User.find_by(id: session[:user]).update({
    name: params[:name],
    mail: params[:mail]
  })

  redirect'/account'

end

post '/account/reset' do

  @tomatoes = current_user.tomatoes.where.not(tomato_start_datetime: "", tomato_end_datetime: "")
  @tomatoes.destroy_all

  redirect '/account'
end

post '/account/update/password' do



end

post '/account/delete' do

  current_user.destroy
  session[:user] = nil

  redirect '/'


end

post '/icon/shuffle' do

  user = User.find_by(id: session[:user])
  user.user_gravatar = SecureRandom.hex(32)
  user.save

  redirect '/account'

end

post '/icon/delete' do

  user = User.find_by(id: session[:user])
  user.user_icon.destoroy

  redirect '/account'

end

post '/z1DNLiBUvP' do

  time = Time.now.getutc + 9 * 60 * 60

  tomato = User.find_by(id: session[:user]).tomatoes.create
  tomato.tomato_start_datetime = time.strftime("%Y/%m/%d %H:%M:%S JST")
  tomato.save


  redirect'/'

end

post '/y1DNKiBUvP' do

  time = Time.now.getutc + 9 * 60 * 60

  tomato = User.find_by(id: session[:user]).tomatoes.last
  tomato.tomato_end_datetime = time.strftime("%Y/%m/%d %H:%M:%S JST")
  tomato.save


  redirect'/'

end

post '/y2ENLiCUvQ' do

  time = Time.now.getutc + 9 * 60 * 60

  tomato = User.find_by(id: session[:user]).tomatoes.last
  tomato.topic = time.strftime("%Y/%m/%d %H:%M:%S JST")
  tomato.save


  redirect'/'

end

get '/interval' do

  @tomato = User.find_by(id: session[:user]).tomatoes.last

erb :interval

end

post '/interval/post' do

  User.find_by(id: session[:user]).tomatoes.last.update({
    topic: params[:topic],
    memo: params[:memo]
  })

  redirect'/'

end