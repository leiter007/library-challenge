require './lib/person.rb'
require 'pry'

describe Person do

    after(:each) do
        original = YAML.load_file('./lib/data_original.yml')
        File.open('./lib/data.yml', 'w') { |f| f.write original.to_yaml }
    end

    subject {described_class.new("Boa")}
    let(:library) { instance_double('Library')}
    
    it 'should have a name when initialized' do
        expect(subject.name).to eq "Boa"
    end

    it 'should be able to view all books that are available' do
        expect(subject.available_books.length).to eq 4
    end
    
    it 'should be able to search for a book based on its title' do
        expected_output = [{:item=>0, :title=>"Alfons och soldatpappan", :author=>"Gunilla Bergström", :available=>true, :return_date=>nil, :borrowed_by=>nil}]
        expect(subject.search_book_by_title("Alfons och soldatpappan")).to eq expected_output
    end

    it 'should be able to search for books based on author' do
        expected_output = [{:item=>3, :title=>"Pippi Långstrump", :author=>"Astrid Lindgren", :available=>true, :return_date=>nil, :borrowed_by=>nil}, {:item=>4, :title=>"Pippi Långstrump går ombord", :author=>"Astrid Lindgren", :available=>true, :return_date=>nil, :borrowed_by=>nil}]
        expect(subject.search_book_by_author("Astrid")).to eq expected_output
    end

    it 'should be able to make it possible to checkout a book, and update the item availability, return date and borrowed by' do
        subject.checkout_book(0)
        new_date = Date.today.next_day(30).strftime('%F')
        collection = YAML.load_file('./lib/data.yml')
        expected_output = {:item=>0, :title=>"Alfons och soldatpappan", :author=>"Gunilla Bergström", :available=>false, :return_date=>new_date, :borrowed_by=>"Boa"}
        expect(collection[0]).to eq expected_output
    end

    it 'should get a success message when book is checked out' do
        new_date = Date.today.next_day(30).strftime('%F')
        expect(subject.checkout_book(0)).to eq "You have borrowed Alfons och soldatpappan. Please return it by #{new_date}"
    end

    it 'should get an "error" message when book is not available' do
        expect(subject.checkout_book(1)).to eq "Book is not available until 2019-05-25. Please come back then"
    end

    it 'should get an "error" message when book has already been borrowed by same person' do
        subject.checkout_book(3)
        expect(subject.checkout_book(3)).to eq "You have already borrowed this book"
    end

    it 'should get an "error" message when item number does not exist' do
        expect(subject.checkout_book(10)).to eq "You have entered an incorrect item number, please try another"
    end

end