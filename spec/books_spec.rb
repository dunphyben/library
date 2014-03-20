require 'spec_helper'

describe Book do
  describe '#initialize' do
    it 'should initialize a book object with a title and an author' do
      new_book = Book.new({:title => 'title', :author => 'author'})
      new_book.should be_an_instance_of Book
    end
  end

  describe '.create' do
    it 'makes new instance of Book alog with saving in dbase' do
      new_book = Book.create({ :title => 'title', :author => 'author'})
      Book.all.should eq [new_book]
    end
  end

  describe '#save' do
    it 'saves an instance to the database' do
      new_book = Book.new({:title => 'title', :author => 'author'})
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
      new_book = Book.create({:title => 'Where the Red Fern Grows', :author => 'Wilson Rawls'})
      new_book.deleted
      Book.all.should eq []
    end
  end

  describe '#update' do
    it 'changes the name and/or author in the object as well as the database' do
      new_book = Book.create({ :title => 'title', :author => 'author'})
      results = new_book.update('Harry Potter', 'JK Rowling')
      results.first['title'].should eq 'Harry Potter'
    end
  end

  describe '.search_title' do
    it 'returns an array containing all of the books with a titles that match the search term' do
      new_book = Book.create({:title => 'Harry Potter', :author => 'JK Rowling'})
      Book.search_title('Harry').should eq [new_book]
    end
  end

  describe '.search_author' do
    it 'returns an array containing all of the books with authors that match the search term' do
      new_book = Book.create({:title => 'Harry Potter', :author => 'JK Rowling'})
      Book.search_author('Rowling').should eq [new_book]
    end
  end

end

