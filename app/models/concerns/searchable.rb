module Searchable
  extend ActiveSupport::Concern

  included do
    self::SEARCH_METHODS.each do |method_name|
      self.define_singleton_method("by_#{method_name}".to_sym) do |arg|
        where("#{method_name} LIKE ?", "%#{arg}%")
      end
    end
  end
end
