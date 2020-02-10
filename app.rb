require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'
require './src/signin-up-out'

require './src/time'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end


get '/' do
  # ユーザー未ログイン時
  unless session[:user]
    erb :index_sign_off

  # ユーザーログイン時
  else
    unless UserSetting.find_by(user_id: session[:user]).nil?
      @user_setting = UserSetting.find_by(user_id: session[:user])
      if current_user.pomodoros.nil?
        @percent = 0
      else
        @pomodoro = current_user.pomodoros.sum(:time)
        @percent = (@pomodoro.to_d / 3600 / @user_setting.goal.to_d * 100).floor(2).to_f
        @study_summary = "#{(@pomodoro.to_d / 3600).floor(2).to_f}""時間/""#{@user_setting.goal}""時間"
      end
    end

    @notices = Notice.limit(5)
    erb :index_sign_on
  end
end

post '/set_goal' do
  goal = current_user.user_settings.create(
    goal: params[:goal]
  )
end

get '/about' do
  erb :about
end

get '/timer' do
  @time = Time.now
  pomodoro = current_user.pomodoros.create(
    time: 0,
    start: @time.timezone('Asia/Tokyo')
  )
  erb :timer
end

post '/pJsDQTKCQSepB8AzkcPmNcEm88VSzwKx' do
  @time = Time.now
  pomodoro = current_user.pomodoros.last.update(
    time: params[:time],
    stop: @time.timezone('Asia/Tokyo')
  )
end

get '/nwnSEUmMbH9L5E3JvJX4WcznifBrZanN' do
  pomodoro = current_user.pomodoros.last.destroy
  redirect '/'
end

get '/interval' do
  erb :interval
end

post '/tQQBu3FNVhG2AKRv4G9aRRuiqc4nWbmx' do
  pomodoro = current_user.pomodoros.last.update(
    did: params[:did],
    understand: params[:understand],
    next: params[:next]
  )
end

get '/chart' do
  erb :chart
end

get '/todo' do
  erb :todo
end

get '/settings' do
  erb :settings
end

get '/administrator' do
  erb :administrator
end

post '/administrator' do
  if params[:user] == 'administrator' && params[:password] == 'cai'
    erb :manage
  else
    redirect '/'
  end
end

post '/make_notice' do
    @notice = Notice.create(
    title: params[:title],
    content: params[:content])
  erb :manage
end