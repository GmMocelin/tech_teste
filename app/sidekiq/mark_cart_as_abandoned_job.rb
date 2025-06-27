class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    # 1. Marcar carrinhos como abandonados após 3h sem interação
    Cart.where(status: 'active')
        .where('last_interaction_at < ?', 3.hours.ago)
        .find_each do |cart|
          cart.update!(status: 'abandoned', abandoned_at: Time.current)
        end

    # 2. Remover carrinhos abandonados há mais de 7 dias
    Cart.where(status: 'abandoned')
        .where('abandoned_at < ?', 7.days.ago)
        .find_each(&:destroy)
  end
end
