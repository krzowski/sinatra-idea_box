require './logic/idea'

class IdeaBoxApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index, locals: { ideas: Idea.all }
  end

  post '/' do
    Idea.new(params['idea_title'], params['idea_description']).save
    redirect '/'
  end

  not_found do
    erb :error
  end
end