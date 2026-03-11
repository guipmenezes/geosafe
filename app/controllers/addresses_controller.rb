# frozen_string_literal: true

class AddressesController < ApplicationController
  def new; end

  def create
    @address = Address.new(address_params)
    @address.user = Current.user

    if @address.save
      redirect_to plans_path, notice: 'Endereço cadastrado com sucesso'
    else
      render :new, status: :unprocessable_content
    end
  end

  def reverse_geocode
    results = Geocoder.search([params[:lat], params[:lng]], language: 'pt-BR')
    if results.any?
      result = results.first
      
      # Extract components with multiple possible types for Brazil
      components = result.data["address_components"] || []
      
      street = components.find { |c| c["types"].intersect?(%w[route street_address]) }&.dig("long_name")
      neighborhood = components.find { |c| c["types"].intersect?(%w[sublocality sublocality_level_1 neighborhood]) }&.dig("long_name")
      city = components.find { |c| c["types"].include?("administrative_area_level_2") || c["types"].include?("locality") }&.dig("long_name")

      if street.present? && neighborhood.present?
        formatted_address = "#{street}, #{neighborhood}"
      elsif street.present? && city.present?
        formatted_address = "#{street}, #{city}"
      elsif result.address.present?
        # Fallback to the first two parts of the formatted address (usually Street, Number or Street, Bairro)
        formatted_address = result.address.split(",").first(2).map(&:strip).join(", ")
      else
        formatted_address = "Localização identificada"
      end

      render json: { address: formatted_address }
    else
      render json: { address: "Localização desconhecida" }, status: :not_found
    end
  end

  private

  def address_params
    params.require(:address).permit(:cep, :uf, :address, :number, :complement, :city, :state)
  end
end
