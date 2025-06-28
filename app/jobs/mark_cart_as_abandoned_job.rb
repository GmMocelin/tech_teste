class MarkCartAsAbandonedJob < ApplicationJob
  queue_as :default

  def perform
    # Marcar carrinhos abandonados
    Cart.where("updated_at < ?", 1.hour.ago).update_all(status: 'abandoned')
  end
end