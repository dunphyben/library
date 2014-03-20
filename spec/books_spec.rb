require 'spec_helper'

describe Book do
  describe '#initialize' do
    it 'should initialize a book object with a title and an author' do
      new_book = Book.new({:title => 'title'})
      new_book.should be_an_instance_of Book
    end
  end

  describe '.create' do
    it 'makes new instance of Book alog with saving in dbase' do
      new_book = Book.create({ :title => 'title'})
      Book.all.should eq [new_book]
    end
  end

  describe '#save' do
    it 'saves an instance to the database' do
      new_book = Book.new({:title => 'title'})
      new_book.save
      Book.all.should eq [new_book]
    end
  end

  describe '.all' do
    it 'should be empty to start with' do
      Book.all.should eq []
    end
  end

  describe '#delete' do
    it 'deletes an instance from the database' do
      new_book = Book.create({:title => 'Where the Red Fern Grows'})
      new_book.deleted
      Book.all.should eq []
    end
  end

  describe '#update' do
    it 'changes the name and/or author in the object as well as the database' do
      new_book = Book.create({ :title => 'title'})
      results = new_book.update('Harry Potter')
      results.first['title'].should eq 'Harry Potter'
    end
  end

  describe '.search_title' do
    it 'returns a hash containing all of the books with a titles that match the search term' do
      new_book = Book.create({:title => 'Harry Potter'})
      new_author = Author.create({:name => 'JK Rowling'})
      new_book.add_combos([new_author.id])
      results = Book.search_title('Harry')
      results[0].title.should eq 'Harry Potter'
    end
  end



  describe '.add_combos' do
    it 'adds a record to the books_authors table with the given author and book ids' do
      test_book = Book.create({:title => 'Matilda'})
      test_author = Author.create({:name => 'Roald Dahl'})
      results = test_book.add_combos([test_author.id])
      results.first.should be_an_instance_of Fixnum
    end
  end

  describe 'books_authors' do
    it 'lists the book with its corresponding authors' do
      test_book = Book.create({:title => 'A Tale of Two Cities'})
      test_author1 = Author.create({:name => 'William Shakespeare'})
      test_author2 = Author.create({:name => 'Charles Dickens'})
      results = test_book.add_combos([test_author1.id, test_author2.id])
      test_book.books_authors.should eq [test_author1, test_author2]
    end
  end

end

