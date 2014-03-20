require 'spec_helper'

describe Author do
  describe '#initialize' do
    it 'creates an instance of Author class' do
      test_author = Author.new({ :name => 'Irving Welsh' })
      test_author.should be_an_instance_of Author
    end
  end

  describe '.all' do
    it 'starts out empty' do
      Author.all.should eq []
    end
  end


end
