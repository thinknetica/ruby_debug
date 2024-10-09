require 'rails_helper'
require 'vcr'
require 'webmock/rspec'

RSpec.describe TodoService do
  let(:service) { TodoService.new }
  let(:todo_id) { 1 }

  before :all do
    Timecop.freeze '1.1.2024'
  end

  describe '#fetch_todo', vcr: true do
    it 'fetches the todo item by id' do
      todo = service.fetch_todo(todo_id)
      expect(todo['id']).to eq(todo_id)
      expect(todo['title']).to eq('delectus aut autem')
      expect(todo['completed']).to be_falsey
    end

    it 'handles errors gracefully' do
      allow(HTTParty).to receive(:get).and_raise(StandardError.new("Network error"))
      result = service.fetch_todo(todo_id)
      expect(result).to eq({ error: "Network error" })
    end
  end
end