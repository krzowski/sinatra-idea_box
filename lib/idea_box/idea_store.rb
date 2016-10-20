require 'yaml/store'

class IdeaStore
  # return all ideas
  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  # return all ideas that share the same tag
  def self.all_by_tag(tag)
    ideas = []
    raw_ideas.each_with_index do |data, i| 
      ideas << Idea.new(data.merge("id" => i)) if data["tags"].split(' ').include? tag
    end
    ideas
  end

  # create a new idea
  def self.create(data)
    data['date'] = DateTime.now
    database.transaction do 
      database['ideas'] << data
    end
  end

  # return the database, create a new one if doesn't exist
  def self.database
    return @database if @database

    @database = YAML::Store.new "db/ideabox"
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  # delete an idea
  def self.delete(id)
    database.transaction do
      database['ideas'].delete_at(id)
    end
  end

  # return the idea with given id
  def self.find(id)
    idea = find_idea(id)
    Idea.new(idea.merge("id" => id))
  end

  def self.find_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  # return ideas in the form of a hash
  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  # update an idea
  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
      database["ideas"][id]["date"] = DateTime.parse(data["date"])
    end
  end
end