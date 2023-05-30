class Api::SessionsController < Api::ApiController 
    def new
        render json: {notice: "Welcome to Crime Record Management System"}, status: 200
    end
end