require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe "#total_price" do
    it "calculates the total price as quantity times product price" do
      product = create(:product, price: 10.0)
      cart_item = build(:cart_item, product: product, quantity: 3)

      expect(cart_item.total_price).to eq(30.0)
    end
  end

  describe "associations" do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  describe "validations" do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
