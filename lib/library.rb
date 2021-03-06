require 'yaml'
require 'date'
STANDARD_RETURN_DAYS = 30

class Library
    attr_accessor :collection, :available_books, :non_available_books
    def initialize
        @collection = YAML.load_file('./lib/data.yml')
    end

def save_updates
    File.open('./lib/data.yml', 'w') { |f| f.write collection.to_yaml }
end

def show_available_books
    collection.select { |obj| obj[:available] == true }
end

def show_non_available_books
    collection.select { |obj| obj[:available] == false  }
end

def search_book_by_title(title)
    collection.select { |obj| obj[:title].include? title }
end

def search_book_by_author(author)
    collection.select { |obj| obj[:author].include? author }
end

def checkout_book(book, name)
    collection[book][:available] = false 
    collection[book][:return_date] = Date.today.next_day(STANDARD_RETURN_DAYS).strftime('%F')
    collection[book][:borrowed_by] = name
    save_updates
end
end
