module Filterable
  extend ActiveSupport::Concern

  included do
    self::FILTER_METHODS.each do |method_name|
      self.define_singleton_method("by_#{method_name}".to_sym) do |arg|
        where("#{method_name}": arg)
      end
    end
  end
end
