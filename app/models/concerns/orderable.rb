module Orderable
  extend ActiveSupport::Concern

  included do
    self::ORDER_METHODS.each do |method_name|
      self.define_singleton_method("order_by_#{method_name}".to_sym) do
        order(method_name)
      end
    end
  end
end
