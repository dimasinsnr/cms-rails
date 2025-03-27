class LeadsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      if current_user.sales?
        @leads = Lead.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(10)
      elsif current_user.manager?
        @leads = Lead.where(status: 'waiting').order(created_at: :desc).page(params[:page]).per(10)
      else
        @leads = Lead.order(created_at: :desc).page(params[:page]).per(10)
      end
      @start_index = (@leads.current_page - 1) * @leads.limit_value + 1
      @products = Product.all
    end

    def create
      authorize! :create, Lead
      begin
        if params[:lead][:id].present?
          @lead = Lead.find_by(id: params[:lead][:id])
          
          if @lead.nil?
            render json: {
              success: false,
              message: 'Lead not found.'
            }, status: :not_found and return
          end
          
          @lead.name = params[:lead][:name]
          @lead.email = params[:lead][:email]
          @lead.phone = params[:lead][:phone]
          @lead.status = 'draf'
          @lead.product_id = params[:lead][:product_id]
          @lead.user_id = current_user.id

          message = 'Lead updated successfully.'
        else
          @lead = Lead.new(lead_params)
          @lead.status = 'draf'
          @lead.user_id = current_user.id

          message = 'Lead created successfully.'
        end
        
        if @lead.save
          render json: {
            success: true,
            message: message,
            lead: @lead
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Failed to save lead.',
            errors: @lead.errors.full_messages
          }, status: :unprocessable_entity
        end

      rescue => e
        render json: {
          success: false,
          message: 'An error occurred while saving the lead.',
          error: e.message
        }, status: :internal_server_error
      end
    end

    def destroy
      @lead = Lead.find_by(id: params[:id]) 
      
      if @lead
        @lead.destroy
        render json: { success: true, message: 'Lead deleted successfully.' }
      else
        render json: { success: false, message: 'Lead not found.' }, status: :not_found
      end
    end

    def ajukan
      @lead = Lead.find_by(id: params[:id])
  
      if @lead.present?
        @lead.update(status: 'waiting')
  
        if @lead.save
          render json: { success: true, message: 'Lead berhasil diajukan.' }
        else
          render json: { success: false, message: 'Gagal mengubah status lead.' }
        end
      else
        render json: { success: false, message: 'Lead tidak ditemukan.' }
      end
    end

    def approve
      approve_data = approve_params
      @lead = Lead.find_by(id: approve_data[:id])
  
      unless @lead
        render json: { success: false, message: 'Lead not found' }, status: :not_found
        return
      end
  
      action = approve_data[:action]
  
      if action == 'approved'
        @lead.status = 'approved'
        
        if @lead.save
          product_id_value = @lead.product.present? ? @lead.product.id : nil
  
          Customer.create(
            name: @lead.name, 
            email: @lead.email, 
            phone: @lead.phone, 
            product_id: product_id_value
          )
  
          render json: { success: true, message: 'Lead has been approved successfully' }
        else
          render json: { success: false, message: 'There was an error updating the lead' }, status: :unprocessable_entity
        end
      elsif action == 'rejected'
        @lead.status = 'rejected'
        
        if @lead.save
          render json: { success: true, message: 'Lead has been rejected' }
        else
          render json: { success: false, message: 'There was an error updating the lead' }, status: :unprocessable_entity
        end
      else
        render json: { success: false, message: 'Invalid action' }, status: :unprocessable_entity
      end
    end
  
    private
  
    def lead_params
      params.require(:lead).permit(:name, :email, :phone, :status, :product_id, :user_id)
    end

    def approve_params
      params.require(:approve).permit(:id, :action)
    end
  end