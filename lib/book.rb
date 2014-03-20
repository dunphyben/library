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
    results = DB.exec("INSERT INTO books (title VALUES ('#{@title}') RETURNING id;")
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
    # self.title == other_book.title && self.author == other_book.author
  end

  def deleted
    DB.exec("DELETE FROM books WHERE id = #@id;")
  end

  def update(title, author)
    @title = title
    @author = author
    DB.exec("UPDATE books SET title = '#{@title}', author ='#{@author}' WHERE id = #{@id} RETURNING title, author;")
  end

  def self.search_title(search_term)
    results = DB.exec("SELECT * FROM books WHERE title LIKE '%#{search_term}%'")
    books = []
    results.each do |result|
      books << Book.new({ :title => result['title'], :author => result['author'], :id => result['id'].to_i })
    end
    books
  end

   def self.search_author(search_term)
    results = DB.exec("SELECT * FROM books WHERE author LIKE '%#{search_term}%'")
    books = []
    results.each do |result|
      books << Book.new({ :title => result['title'], :author => result['author'], :id => result['id'].to_i })
    end
    books
  end

end
