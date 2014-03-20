require './lib/book'
require 'pg'

DB = PG.connect(:dbname => 'library')

def main_menu
  print "\n\n********* WELCOME TO THE LIBRARY **********\n\n"
  puts "Press 'l' if you are a librarian"
  puts "Press 'p' if you are a patron"
  puts "Press 'x' to exit"

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

def librarian_menu
  print "\n\n********* LIBRARIAN MENU **********\n\n"
  puts "Press 'n' to add a new book to the inventory"
  puts "Press 'l' to list all books in the inventory"
  puts "Press 't' to search for a book by title"
  puts "Press 'a' to search for a book by author"
  puts "Press 'u' to update a book"
  puts "Press 'd' to delete a book from inventory"
  puts "Press 'm' to return to the main menu"

  user_choice = gets.chomp

  case user_choice
  when 'n'
    add_book
    librarian_menu
  when 'l'
    list_books
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
  when 'u'
    update_book
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
  print "Enter author name: "
  author = gets.chomp
  Book.create({ :title => title, :author => author})
  puts "The book #{title} by #{author} was created successfully!"
end

def list_books
  puts "\nThe current books in inventory are: "
  Book.all.each_with_index do |book, index|
    puts "#{index + 1}. #{book.title} by #{book.author}"
  end
end

def delete_book
  list_books
  puts "Enter the title of the book you would like to delete"
  delete_choice = gets.chomp
  book_to_delete = Book.search_title(delete_choice).first
  book_to_delete.deleted
  puts "The book #{book_to_delete.title} by #{book_to_delete.author} was successfully deleted!"
end

def search_by_title
  print "Enter title to search books by: "
  search_term = gets.chomp
  list = Book.search_title(search_term)
  list.each_with_index do |book, index|
    puts "#{index + 1}. #{book.title} by #{book.author}"
  end
end

def search_by_author
  print "Enter author to search books by: "
  search_term = gets.chomp
  list = Book.search_author(search_term)
  list.each_with_index do |book, index|
    puts "#{index + 1}. #{book.title} by #{book.author}"
  end
end

def update_book
  list_books
  print "Enter the number of the book you would like to update: "
  book_choice = gets.chomp
  book_to_update = Book.all[book_choice.to_i - 1]
  print "Enter the new title of the book: "
  new_title = gets.chomp
  print "Enter the new author of the book: "
  new_author = gets.chomp
  book_to_update.update(new_title, new_author)
  puts "The book #{new_title} by #{new_author} was successfully updated."
end

main_menu
