module Search
  class DailyReport
    include ActiveModel::Model

    attr_accessor :user_id, :user_name_like, :from, :to, :sort, :order_by

    validates :sort, inclusion: { in: %w[user_id, title, created_at, updated_at] }, allow_nil: true

    def search
      reports = ::DailyReport.joins(:user)
      reports = reports.where(user_id: user_id) if user_id.present?
      reports = reports.where("users.name LIKE ?", "%#{user_name_like}%") if user_name_like.present?
      reports = reports.where("created_at >= ?", "#{from}") if from.present?
      reports = reports.where("created_at <= ?", "#{to}") if to.present?
      reports = reports.order(converted_sort.to_sym => converted_order_by)
      reports
    end

    private

    def converted_sort
      return "id" if sort.blank?

      sort
    end

    def converted_order_by
      return "DESC" if order_by.blank?

      order_by
    end
  end
end
