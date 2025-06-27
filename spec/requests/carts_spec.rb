require 'rails_helper'

RSpec.describe "/carts", type: :request do
  describe "POST /add_item" do
    let!(:cart) { FactoryBot.create(:cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { CartItem.create!(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_item', params: { product_id: product.id, quantity: 2 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
