# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    association :user
    cep { '70000-000' }
    uf { 'DF' }
    city { 'Brasília' }
    state { 'Distrito Federal' }
    address { 'Praça dos Três Poderes' }
    number { 'S/N' }
    label { 'Casa' }
    latitude { -15.7991 }
    longitude { -47.8641 }
  end
end
