class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui
before_action :set_cart

  def show
    render json: cart_payload
  end

  def create
    product = Product.find_by(id: params[:product_id])
    return render json: { error: "Produto não encontrado" }, status: :not_found unless product

    item = @cart.cart_items.find_or_initialize_by(product: product)
    item.quantity ||= 0
    item.quantity += params[:quantity].to_i

    if item.quantity <= 0
      return render json: { error: "Quantidade deve ser maior que zero" }, status: :unprocessable_entity
    end

    item.save!
    @cart.update!(last_interaction_at: Time.current)

    render json: cart_payload
  end

  def add_item
    product = Product.find_by(id: params[:product_id])
    return render json: { error: "Produto não encontrado" }, status: :not_found unless product
    
    item = @cart.cart_items.find_or_initialize_by(product: product)
    
    quantity = params[:quantity].to_i
    if quantity <= 0
      return render json: { error: "Quantidade deve ser maior que zero" }, status: :unprocessable_entity
    end
    
    item.quantity += quantity
    item.save!
    @cart.update!(last_interaction_at: Time.current)
    
    render json: cart_payload
  end

  def destroy
    item = @cart.cart_items.find_by(product_id: params[:product_id])
    if item
      item.destroy
      @cart.update!(last_interaction_at: Time.current)
      render json: cart_payload
    else
      render json: { error: "Produto não encontrado no carrinho" }, status: :not_found
    end
  end

  private

  def set_cart
    @cart = Cart.first_or_create
  end

  def cart_payload
    {
      id: @cart.id,
      products: @cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.total_price
        }
      end,
      total_price: @cart.total_price
    }
  end
end
