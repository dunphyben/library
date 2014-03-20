class Book
  attr_reader :id, :title

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def self.create(attributes)
    new_book = Book.new(attributes)
    new_book.save
    new_book
  end

  def save
    results = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM books;")
    all = []
    results.each do |result|
      title = result['title']
      id = result['id'].to_i
      all << Book.new({:title => title, :id => id})
    end
    all
  end

  def ==(other_book)
    self.id == other_book.id
  end

  def deleted
    DB.exec("DELETE FROM books WHERE id = #@id;")
  end

  def update(title)
    @title = title
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{@id} RETURNING title;")
  end

  def add_combos(author_ids)
    # author_ids.each_with_index do |author_id, index|
    author_ids.select do |author_id|

    DB.exec("INSERT INTO books_authors (author_id, book_id) VALUES (#{author_id}, #{self.id}) RETURNING id;")
    end
  end

  def self.search_title(search_term)
    results = DB.exec("SELECT title, id FROM books WHERE LOWER(title) LIKE '%#{search_term.downcase}%';")
    books = []
    results.each do |result|
      id = result['id'].to_i
      title = result['title']
      books << Book.new({:id => id, :title => title})
    end
    books
  end

  def books_authors
    results = DB.exec("SELECT authors.name, authors.id FROM books_authors INNER JOIN books ON (books.id = books_authors.book_id) INNER JOIN authors ON (authors.id = books_authors.author_id) WHERE books.id = #{self.id};")
    authors = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      authors << Author.new({:name => name, :id => id})
    end
    authors
  end

  #  def self.search_author(search_term)
  #   results = DB.exec("SELECT * FROM books WHERE author LIKE '%#{search_term}%'")
  #   books = []
  #   results.each do |result|
  #     books << Book.new({ :title => result['title'], :author => result['author'], :id => result['id'].to_i })
  #   end
  #   books
  # end

end
