module Searchable
  extend ActiveSupport::Concern

  included do
    self::SEARCH_METHODS.each do |method_name|
      self.define_singleton_method("by_#{method_name}".to_sym) do |arg|
        where("#{method_name} LIKE ?", "%#{arg}%")
      end
    end

    def self.search(search_term='')
      return all unless search_term

      results = []

      self::SEARCH_METHODS.each_with_index do |method, index|
        if index == 0
          results = self.public_send("by_#{method}", search_term)
        else
          results = results.or(self.public_send("by_#{method}", search_term))
        end
      end

      results
    end
  end
end
