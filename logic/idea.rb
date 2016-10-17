require 'yaml/store'

class Idea
  attr_reader :title, :description

  def initialize(data)
    @title = data['title']
    @description = data['description']
  end

  def self.all
    raw_ideas.map do |data|
      Idea.new(data)
    end
  end

  def self.database
    @database ||= YAML::Store.new "ideabox"
  end
  def database
    Idea.database
  end

  def self.delete(id)
    database.transaction do
      database['ideas'].delete_at(id)
    end
  end

  def self.find(id)
    idea = find_idea(id)
    Idea.new(idea)
  end

  def self.find_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def save
    database.transaction do |db|
      db['ideas'] ||= []
      db['ideas'] << { 'title' => title, 'description' => description }
    end
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end
end