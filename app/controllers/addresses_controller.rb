class AddressesController < ApplicationController
  skip_before_action :authenticate, only: :create

  def new
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      redirect_to root_path, notice: "Endereço cadastrado com sucesso"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:cep, :uf, :address, :complement, :city, :state)
  end
end
