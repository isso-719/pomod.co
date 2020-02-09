require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  has_many :user_settings
  has_many :pomodoros
end

class UserSettings < ActiveRecord::Base
  belongs_to :user
end

class Pomodoro < ActiveRecord::Base
  belongs_to :user
end

class Notice < ActiveRecord::Base
end