class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true
  belongs_to :merchant

  def self.find_all_items(name)
    where("name ILIKE ?", "%#{name}%")
  end
end
