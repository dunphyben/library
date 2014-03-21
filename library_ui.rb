require './lib/book'
require './lib/author'
require 'pg'

DB = PG.connect(:dbname => 'library')

def main_menu
  print "\n\n********* WELCOME TO THE LIBRARY **********\n\n"
  puts "Press 'l' if you are a librarian"
  puts "Press 'p' if you are a patron"
  puts "Press 'x' to exit\n\n"

  main_choice = gets.chomp

  case main_choice
  when 'l'
    librarian_menu
  when 'p'
    patron_menu
  when 'x'
    puts "Good bye!"
    exit
  else
    puts "That input was invalid. Please choose again."
    main_menu
  end
end

# def librarian_menu
#   print "\n\n********* LIBRARIAN MENU **********\n\n"
#   puts "Press 'n' to add a new book to the inventory"
#   puts "Press 'l' to list all books in the inventory"
#   puts "Press 't' to search for a book by title"
#   puts "Press 'a' to search for a book by author"
#   puts "Press 'u' to update a book"
#   puts "Press 'd' to delete a book from inventory"
#   puts "Press 'm' to return to the main menu"

  def librarian_menu
  print "\n\n", " "*8, "*"*20, " LIBRARIAN MENU ", "*"*20, "\n\n"
  puts "\tPress 'n' to add a new book to the inventory",
       "\tPress 'l' to list all books in the inventory",
       "\tPress 'v' to list all authors in the inventory",
       "\tPress 't' to search for a book by title",
       "\tPress 'a' to search for a book by author",
       "\tPress 'b' to update a book",
       "\tPress 'u' to update an author",
       "\tPress 'd' to delete a book from inventory",
       "\tPress 'm' to return to the main menu\n\n"

  user_choice = gets.chomp

  case user_choice
  when 'n'
    add_book
    librarian_menu
  when 'l'
    list_books
    puts "\n\n***** Press enter to return to the Librarian Menu"
    gets
    librarian_menu
  when 'v'
    list_authors
    puts "\n\n***** Press enter to return to the Librarian Menu"
    gets
    librarian_menu
  when 't'
    search_by_title
    gets
    librarian_menu
  when 'a'
    search_by_author
    gets
    librarian_menu
  when 'b'
    update_book
    gets
    librarian_menu
  when 'u'
    update_author
    gets
    librarian_menu
  when 'd'
    delete_book
    gets
    librarian_menu
  when 'm'
    main_menu
  else
    puts "That was not a valid choice. Please choose again."
    librarian_menu
  end
end

def add_book
  print "\n\n********* Add Book **********\n\n"
  print "Enter book title: "
  title = gets.chomp
  print "Enter author names: "
  author = gets.chomp

  new_book = Book.create({ :title => title})
  new_author = correct_author(author)
  author_ids = [new_author.id]
  author_names = [new_author.name]

  more_authors = true
  while more_authors
    puts "Are there more authors? (y/n): "
    more_author_choice = gets.chomp.downcase
    if more_author_choice == 'y'
      print "Enter author names: "
      author = gets.chomp
      new_author = correct_author(author)
      author_ids << new_author.id
      author_names << new_author.name
    elsif more_author_choice == 'n'
      more_authors = false
    else
      puts "That input was not valid. Please try again."
    end
  end

  new_book.add_combos(author_ids)
  puts "The book #{title} by #{author_names.join(' and ')} was created successfully!"
end

def list_books
  puts "\nThe current books in inventory are: \n"
  Book.all.each_with_index do |book, index|
    books_authors = book.books_authors.collect{|author| author.name}
    puts "\t#{index + 1}. #{book.title} by #{books_authors.join(' and ')}"
  end
end

def list_authors
  puts "\nThe current authors in inventory are: \n"
  Author.all.each_with_index do |author, index|
    puts "\t#{index + 1}. #{author.name}"
  end
end

def correct_author(author_name)
  if Author.search_author(author_name) == []
    new_author = Author.create({:name => author_name})
  else
    new_author = Author.search_author(author_name).first
  end
  new_author
end

def delete_book
  list_books
  puts "Enter the title of the book you would like to delete"
  delete_choice = gets.chomp
  book_to_delete = Book.search_title(delete_choice).first

  authors = book_to_delete.books_authors
  if authors.length == 1 && authors[0].authors_books.length == 1
    authors[0].deleted
  end
  book_to_delete.deleted
  puts "The book #{book_to_delete.title} was successfully deleted!"
end

def search_by_title
  print "Enter title to search books by: "
  search_term = gets.chomp
  list = Book.search_title(search_term)
  list.each_with_index do |book, index|
    books_authors = book.books_authors.collect{|author| author.name}
    puts "#{index + 1}. #{book.title} by #{books_authors.join(' and ')}"
  end
end

def search_by_author
  print "Enter author to search books by: "
  search_term = gets.chomp
  list = Author.search_author(search_term)
  list.each_with_index do |author, index|
    books_titles = author.authors_books.collect{|book| book.title}
    puts "#{index + 1}. #{author.name} has authored the following books: "
    puts books_titles.join("\n")
  end
end

def update_book
  list_books
  print "Enter the number of the book you would like to update: "
  book_choice = gets.chomp
  book_to_update = Book.all[book_choice.to_i - 1]
  print "Enter the new title of the book: "
  new_title = gets.chomp
  book_to_update.update(new_title)
  puts "The book #{new_title} was successfully updated."
end

def update_author
  list_authors
  print "Enter the number of the author you would like to update: "
  author_choice = gets.chomp
  author_to_update = Author.all[author_choice.to_i - 1]
  print "Enter the new name of the author: "
  new_name = gets.chomp
  author_to_update.update(new_name)
  puts "The author #{new_name} was successfully updated."
end



main_menu
