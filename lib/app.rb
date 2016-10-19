require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  enable :sessions
  set :method_override, true
  set :root, 'lib/app'

  # automatically reload app on changes made 
  configure :development do
    register Sinatra::Reloader
  end


  get '/' do
    erb :index, locals: { ideas: IdeaStore.all_by_tag(tag) } if session[:tag]
    erb :index, locals: { ideas: IdeaStore.all.sort }
  end

  # access root page without session
  get '/index' do
    session.clear
    redirect '/'
  end


  # CRUD paths for Idea
  post '/' do
    IdeaStore.create( params['idea'] )
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: { idea: idea }
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params['idea'])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end


  # change the priority of an idea
  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/:id/dislike' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.dislike!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end


  # get all ideas that share a tag
  get '/tag/:tag' do |tag|
    session[:tag] = tag
    redirect '/' erb :tag, locals: { ideas: IdeaStore.all_by_tag(tag).sort }
  end


  not_found do
    erb :error
  end
end