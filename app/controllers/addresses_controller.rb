# frozen_string_literal: true

class AddressesController < ApplicationController
  def new; end

  def create
    @address = Address.new(address_params)
    @address.user = Current.user

    if @address.save
      redirect_to plans_path, notice: 'Endereço cadastrado com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:cep, :uf, :address, :number, :complement, :city, :state)
  end
end
