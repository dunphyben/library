require 'spec_helper'

describe Author do
  describe '#initialize' do
    it 'creates an instance of Author class' do
      test_author = Author.new({ :name => 'Irving Welsh' })
      test_author.should be_an_instance_of Author
    end
  end

  describe '.create' do
    it 'makes new instance of Author alog with saving in dbase' do
      new_author = Author.create({:name => 'Stephen King'})
      Author.all.should eq [new_author]
    end
  end

  describe '.all' do
    it 'starts out empty' do
      Author.all.should eq []
    end
  end

  describe '#save' do
    it 'saves an author instance to the database' do
      test_author = Author.new({:name => 'JK Rowling'})
      test_author.save
      Author.all.should eq [test_author]
    end
  end

  describe '==' do
    it 'returns true if two author objects have the same database id' do
      test_author1 = Author.new({:name => 'Stephen King'})
      test_author2 = Author.new({:name => 'Stephen King'})
      test_author1.should eq test_author2
    end
  end

  describe '.add_combos' do
    it 'adds a record to the books_authors table with the given author and book ids' do
      test_book = Book.create({:title => 'Matilda'})
      test_author = Author.create({:name => 'Roald Dahl'})
      results = test_author.add_combos([test_book.id])
      results.first.should be_an_instance_of Fixnum
    end
  end

  describe '.search_author' do
    it 'returns an array of authors that match the search term' do
      new_author = Author.create({:name => 'JK Rowling'})
      new_book = Book.create({:title => 'Harry Potter'})
      new_book.add_combos([new_author.id])
      results = Author.search_author('Rowling')
      results[0].should eq new_author
    end
  end

  describe '#authors_books' do
    it 'returns an array with all the books by this author' do
      new_author = Author.create({:name => 'Steven Hawking'})
      new_book1 = Book.create({:title => 'A Brief History of Time'})
      new_book2 = Book.create({:title => 'A Briefer History of Time'})
      new_author.add_combos([new_book1.id, new_book2.id])
      new_author.authors_books.should eq [new_book1, new_book2]

    end
  end

  describe '#update' do
    it 'sets the name of the author to the given name and updates the database' do
      new_author = Author.create({:name => 'Steven Hawking'})
      new_author.update('Stephen Hawking')
      new_author.name.should eq 'Stephen Hawking'
    end
  end


end
