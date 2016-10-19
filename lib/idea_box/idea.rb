class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id, :tags, :date

  def initialize(data = {})
    @title = data['title']
    @description = data['description']
    @rank = data['rank'] || 0
    @id = data['id']
    @tags = data['tags']
    @date = data['date']
  end

  def dislike!
    @rank -= 1
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
      "rank" => rank,
      "tags" => tags,
      "date" => date
    }
  end

  def <=>(other)
    other.rank <=> rank
  end
end