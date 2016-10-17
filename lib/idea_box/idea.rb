class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id

  def initialize(data = {})
    @title = data['title']
    @description = data['description']
    @rank = data['rank'] || 0
    @id = data['id']
  end

  def like!
    @rank += 1
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    { "title" => title, 
      "description" => description, 
      "rank" => rank
    }
  end

  def <=>(other)
    other.rank <=> rank
  end
end