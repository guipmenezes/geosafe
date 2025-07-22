class Address < ApplicationRecord
  belongs_to :user

  validates :cep, :uf, :city, :state, :address, :number, presence: true
end
