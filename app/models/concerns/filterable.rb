module Filterable
  extend ActiveSupport::Concern

  included do
    self::FILTER_METHODS.each do |method_name|
      self.define_singleton_method("by_#{method_name}".to_sym) do |arg|
        where("#{method_name}": arg)
      end
    end

    def self.filter_by(collection, filter_params)
      filter_params.each do |key, value|
        collection = collection.public_send("by_#{key}", value) if value.present?
      end

      collection
    end
  end
end
