class Author
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.create(attributes)
    new_author = Author.new(attributes)
    new_author.save
    new_author
  end

  def self.all
    results = DB.exec("SELECT * FROM authors;")
    all = []
    results.each do |result|
      all << Author.new({:name => result['name'], :id => result['id'].to_i})
    end
    all
  end

  def save
    results = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(other_author)
    self.id == other_author.id
  end

  def add_combos(book_ids)
   # book_ids.each_with_index do |book_id, index|
   book_ids.select do |book_id|

      DB.exec("INSERT INTO books_authors (author_id, book_id) VALUES (#{self.id}, #{book_id}) RETURNING id;")
    end
  end

  def self.search_author(search_term)
      results = DB.exec("SELECT name, id FROM authors WHERE LOWER(name) LIKE '%#{search_term.downcase}%';")
      authors = []
      results.each do |result|
        id = result['id'].to_i
        name = result['name']
        authors << Author.new({:id => id, :name => name})
      end
      authors
  end

  def authors_books
    results = DB.exec("SELECT books.title, books.id FROM books_authors INNER JOIN books ON (books.id = books_authors.book_id) INNER JOIN authors ON (authors.id = books_authors.author_id) WHERE authors.id = #{self.id};")

    books = []
    results.each do |result|
      book_id = result['id'].to_i
      book_title = result['title']
      books << Book.new({:id => book_id, :title => book_title})
    end
    books
  end

  def deleted
    DB.exec("DELETE FROM authors WHERE id = #@id;")
  end

  def update(name)
    @name = name
    DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id} RETURNING name;")
    end

end
