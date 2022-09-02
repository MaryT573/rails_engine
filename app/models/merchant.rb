class Merchant < ApplicationRecord
    validates :name, presence: true
    has_many :items, dependent: :destroy

    def self.merchant_search(name)
        where("name ILIKE ?", "%#{name}%").order(name: :asc).first
    end
end
