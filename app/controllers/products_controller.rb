class ProductsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
  
    def products
      @products = Product.all

      product_table_html = render_to_string(partial: "products/product_table", locals: { products: @products })
      base64_product_table = Base64.encode64(product_table_html)
  
      render json: { content_base64: base64_product_table }
    end

    def index
      @products = Product.order(created_at: :desc).page(params[:page]).per(10)
      @start_index = (@products.current_page - 1) * @products.limit_value + 1
    end
  
    def new
      @product = Product.new
    end
  
    def create
      if params[:product][:id].present?
        @product = Product.find_by(id: params[:product][:id])
  
        if @product.nil?
          render json: {
            success: false,
            message: 'Product not found.'
          }, status: :not_found and return
        end
  
        @product.name = params[:product][:name]
        @product.price = params[:product][:price]
  
      else
        @product = Product.new(product_params)
      end
  
      begin
        if @product.save
          render json: {
            success: true,
            message: @product.persisted? ? 'Product updated successfully.' : 'Product created successfully.',
            product: @product
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Failed to save product.',
            errors: @product.errors.full_messages
          }, status: :unprocessable_entity
        end
      rescue => e
        render json: {
          success: false,
          message: 'An error occurred while saving the product.',
          error: e.message
        }, status: :internal_server_error
      end
    end

    def destroy
      @product = Product.find_by(id: params[:id]) 
      
      if @product
        @product.destroy
        render json: { success: true, message: 'Product deleted successfully.' }
      else
        render json: { success: false, message: 'Product not found.' }, status: :not_found
      end
    end
  
    private
  
    def product_params
      params.require(:product).permit(:name, :price)
    end
  end