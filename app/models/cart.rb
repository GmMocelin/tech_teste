class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 0, abandoned: 1 }

  before_create :initialize_cart

  def mark_as_abandoned
    update!(status: :abandoned, abandoned_at: Time.current)
  end

  def remove_if_abandoned
    destroy if abandoned? && abandoned_at < 7.days.ago
  end

  def calculate_total_price
    cart_items.includes(:product).sum(&:total_price)
  end

  private

  def initialize_cart
    self.last_interaction_at ||= Time.current
    self.status ||= 'active'
  end
end
