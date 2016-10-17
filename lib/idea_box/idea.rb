class Idea
  attr_reader :title, :description

  def initialize(data)
    @title = data['title']
    @description = data['description']
  end
end