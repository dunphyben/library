class Author
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    results = DB.exec("SELECT * FROM authors;")
    all = []
    results.each do |result|
      all << Author.new({:name => result['name'], :id => result['id'].to_i})
    end
    all
  end

end
