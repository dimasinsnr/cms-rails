class UsersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    def index
        @users = User.order(created_at: :desc).page(params[:page]).per(10)
        @start_index = (@users.current_page - 1) * @users.limit_value + 1
    end

    def create
        if params[:user][:id].present?
            @user = User.find_by(id: params[:user][:id])
    
            if @user.nil?
                render json: {
                    success: false,
                    message: 'User not found.'
                }, status: :not_found and return
            end
    
            @user.email = params[:user][:email]
            @user.role = params[:user][:role]
    
            if params[:user][:password].present?
                @user.password = params[:user][:password] 
            end
        else
            @user = User.new(user_params)
        end
    
        begin
            if @user.save
                render json: {
                    success: true,
                    message: @user.persisted? ? 'User updated successfully.' : 'User created successfully.',
                    user: @user
                }, status: :ok
            else
                render json: {
                    success: false,
                    message: 'Failed to save user.',
                    errors: @user.errors.full_messages
                }, status: :unprocessable_entity
            end
        rescue => e
            render json: {
                success: false,
                message: 'An error occurred while saving the user.',
                error: e.message
            }, status: :internal_server_error
        end
    end

    def destroy
        @user = User.find_by(id: params[:id]) 
        
        if @user
            @user.destroy
            render json: { success: true, message: 'User deleted successfully.' }
        else
            render json: { success: false, message: 'User not found.' }, status: :not_found
        end
    end
    
    private
    
    def user_params
        params.require(:user).permit(:email, :password, :role)
    end
end