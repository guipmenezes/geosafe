namespace :alerts do
  desc "Popula a coluna UF dos alertas existentes"
  task backfill_ufs: :environment do
    puts "Iniciando atualização de UFs..."
    
    Alert.where(uf: nil).find_each do |alert|
      if alert.home_alert? && alert.user&.address
        alert.update_columns(uf: alert.user.address.uf)
        print "."
      elsif alert.street_alert? && alert.latitude.present? && alert.longitude.present?
        result = Geocoder.search([alert.latitude, alert.longitude], language: 'pt-BR').first
        if result
          state_component = result.data['address_components']&.find { |c| c['types'].intersect?(%w[administrative_area_level_1]) }
          uf = state_component&.dig('short_name')
          
          if uf.present?
            alert.update_columns(uf: uf)
            print "."
          else
            print "x"
          end
        else
          print "!"
        end
        sleep 0.1 # Para evitar rate limits do geocoder
      end
    end
    
    puts "\nConcluído!"
  end
end
