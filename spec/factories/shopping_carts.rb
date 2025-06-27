FactoryBot.define do
  factory :shopping_cart, class: 'Cart' do
    total_price { 0 }
    status { 'active' }
    last_interaction_at { Time.current }
  end
end