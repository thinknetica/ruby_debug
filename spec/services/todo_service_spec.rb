require 'rails_helper'
require 'webmock/rspec'

RSpec.describe TodoService, skip: true do
  let(:service) { TodoService.new }
  let(:todo_id) { 1 }
  let(:todo_response) do
    {
      userId: 1,
      id: 1,
      label: 'delectus aut autem',
      completed: false
    }.to_json
  end

  before do
    stub_request(:get, "https://jsonplaceholder.typicode.com/todos/#{todo_id}")
      .to_return(status: 200, body: todo_response, headers: { 'Content-Type' => 'application/json' })
  end

  describe '#fetch_todo' do
    it 'fetches the todo item by id' do
      todo = service.fetch_todo(todo_id)
      expect(todo['id']).to eq(todo_id)
      expect(todo['label']).to eq('delectus aut autem')
      expect(todo['completed']).to be_falsey
    end

    it 'handles errors gracefully' do
      allow(Net::HTTP).to receive(:get).and_raise(StandardError.new("Network error"))
      result = service.fetch_todo(todo_id)
      expect(result).to eq({ error: "Network error" })
    end
  end
end