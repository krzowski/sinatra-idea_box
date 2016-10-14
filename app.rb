require './logic/idea'

class IdeaBoxApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  post '/' do
    idea = Idea.new
    idea.save
    "Create an Idea"
  end

  not_found do
    erb :error
  end
end