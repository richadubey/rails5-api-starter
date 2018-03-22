module API  
  module V1
    class Todos < Grape::API
      include API::V1::Defaults

    
      resource :todos do

        desc "Return all todos"
        get "", root: :todos do
          Todo.all.to_json
        end
        
        desc "Return all todos_list" 
        get "action_cable_todo_list", root: :todos do 
          ActionCable.server.broadcast 'todo', list: Todo.all 
        end

    
       desc "create a new todo"
       params do
        requires :title, type: String
        requires :completed, type:String
        requires :order, type:Integer
       end
       post do
        @todo = Todo.new({title:params[:title],completed:params[:completed],order:params[:order]})
        if @todo.save
          return {success: true, message:  "Record added succesfully" }
        else 
          return { success: false, message: @todo.errors.full_messages }
        end


       end

       desc 'Delete a todo single Record.' 
       params do
         requires :id, type: String, desc: 'Status ID.' 
       end
       delete ':id' do
        if Todo.find(params[:id]).destroy
          return {success: true, message:  "Record deleted succesfully" }
        else 
          return { success: false, message: "some thing went wrong" }
        end
       end
      
      desc "update an todo title"
      params do
        requires :id, type: String
        requires :title, type:String
      end
      put ':id' do
        if Todo.find(params[:id]).update({title:params[:title]})
           return {success: true, message:  "Record update succesfully" }
        else
          return {success: true, message:  "Record update unsuccesfully" }
        end
      end

      desc "Return a todo"
      params do
        requires :id, type: String, desc: "ID of the todo"
      end
      get ":id", root: "todos" do
        Todo.where(id: permitted_params[:id]).first
      end
      end
    end
  end
end  