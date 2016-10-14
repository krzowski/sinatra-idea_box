require './logic/idea'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true

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

  delete '/:id' do |id|
    Idea.delete(id.to_i)
    redirect '/'
  end

  not_found do
    erb :error
  end
end