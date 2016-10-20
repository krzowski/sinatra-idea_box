#  add test coverage 

require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  enable :sessions
  set :method_override, true
  set :root, 'lib/app'

  # automatically reload app on changes made 
  configure :development do
    register Sinatra::Reloader
  end


  # root
  get '/' do
    session.clear
    generate_index
  end


  # CRUD paths for Idea
  post '/' do
    IdeaStore.create( params['idea'] )
    redirect '/'
  end

  get '/:id' do |id|
    erb :idea, locals: { idea: IdeaStore.find(id.to_i)}
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: { idea: idea }
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params['idea'])
    redirect "/#{id}"
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    generate_index
  end


  # change priority of an idea
  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    generate_index
  end

  post '/:id/dislike' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.dislike!
    IdeaStore.update(id.to_i, idea.to_h)
    generate_index
  end


  # get all ideas that share a tag
  get '/tag/:tag' do |tag|
    session.clear
    session[:tag] = tag
    generate_index
  end


  # search for an idea by date of creation
  post '/search' do 
    session.clear
    session[:search] = params['date']
    generate_index
  end


  not_found do
    erb :error, layout: false
  end


  def generate_index
    ideas = session.any? ? get_ideas_from_session : IdeaStore.all
    erb :index, locals: { ideas: ideas.sort }
  end


  def get_ideas_from_session
    if session[:tag]
      ideas = IdeaStore.all_by_tag(session[:tag])
    elsif session[:search]
      ideas = []
      IdeaStore.all.each do |idea|
        date = idea.date
        ideas << idea if "#{date.month}/#{date.day}/#{date.year}" == session[:search]
      end
    end
  end

end