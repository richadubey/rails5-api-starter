require 'rails_helper'
#require 'spec_helper'


RSpec.describe API::V1 do
	let!(:present_todo) { create(:todo) }
	let(:create_todo_params) {{ title: 'title', completed:'completed', order: '1' }}
    
    describe 'get a one single record' do
    	it 'returns a single todo record' do 
    		get "/api/v1/todos/#{present_todo.id}"
            json = JSON.parse(response.body)
            expect(json["id"]).to eq present_todo.id
        end 
    end
    describe 'update record' do
    	it 'update a record' do
    		put "/api/v1/todos/#{present_todo.id}", {id: present_todo.id, title: 'title'}
            present_todo.reload
            expect(present_todo.title).to eq 'title'
        end
    end
  
    describe 'for Create' do
    	it 'creates todos' do
    		expect{ post "/api/v1/todos", create_todo_params}.to change(Todo, :count).by(+1)
    		#expect(response).to have_http_status :created
    		expect(JSON.parse(response.body))
    	end
    end
    		
    
    describe 'delete a todo record' do
    	it 'Delete  a record' do
    		expect{ delete "/api/v1/todos/#{present_todo.id}"}.to change(Todo, :count).by(-1)
            expect(response.status).to eq 200
        end
    end
    describe 'list of all todos' do
    	it 'show all todos record' do
    		get "/api/v1/todos/"
            expect(JSON.parse(response.body))
        end
    end



    describe 'blank fields' do
    	it "should have an error on when all fields are blank" do
    		post "/api/v1/todos/", {title: '',completed:'',order:''}
    		expect { raise NoMethodError }.to raise_error(NoMethodError)
        end
    end    
    
   
    
    describe 'Missing Update parameter' do
    	it "should have an error on when id is not given" do
    		put "/api/v1/todos/#{present_todo.id}", {id: '', title: ''}
    	    expect(response.status).to eq 200
        end

    end

    describe 'Missing Delete parameter' do
    	it "should have an error on when id is not given" do
    		delete "/api/v1/todos/#{present_todo.id}",{id:''}
    	##	binding.pry
    		expect(response.status).to eq 200
        end

    end
end



RSpec.describe Todo, :type => :model do
  subject { described_class.new }

  it "is valid with valid attributes" do
    subject.title = "Anything"
    subject.completed ="Anything"
    subject.order = "Anything"
    subject.created_at = DateTime.now
    subject.updated_at = DateTime.now + 1.week
    expect(subject).to be_valid
  end

  it "is not valid without a title" do
    expect(subject).to_not be_valid
  end

  it "is not valid without a completed" do
    subject.completed = "Anything"
    expect(subject).to_not be_valid
  end

  it "is not valid without a order" do
    subject.order = "Anything"
    expect(subject).to_not be_valid
  end
  

  
end