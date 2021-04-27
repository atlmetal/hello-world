module Hotels
  class AddAccommodationMappingService < ApplicationService
    attr_reader :accommodation_file, :hotel, :message_struct

    def initialize(accommodation_file, user, hotel)
      @accommodation_file = accommodation_file
      @user = user
      @hotel = hotel
      @message_struct = []
    end

    def call
      converter = lambda { |header| header.downcase }
      data = CSV.parse(File.read(accommodation_file), headers: true, header_converters: converter)

      data.each_with_index do |row, index|
        row_index = index + 2
        name = row['número_habitación'].to_s

        if name.empty?
          message_struct << "Field room number is empty on row #{row_index}"
          next
        end

        minimum_rate = row['tarifa_mínima'].to_d
        category = row['categoría'].downcase.to_sym

        room_type_name = row['acomodación'].to_s.capitalize
        room_type = get_room_type(room_type_name, row_index, category)
        next unless room_type

        floor = row['número_de_piso'].to_i
        marketable = row['¿comercializable?'].to_s
        observations = row['observaciones'].to_s
        online_sell = marketable == 'si'

        scores = {
          tv: row['tv'].to_i, paint: row['estado_de_la_pintura'].to_i,
          water: row['agua_corriente'].to_i, bathroom: row['baño_independiente'].to_i,
          mattress: row['estado_del_colchón'].to_i, electricity: row['energía'].to_i,
          blankets: row['sábanas_blancas'].to_i, overall_state: row['estado_general'].to_i
        }

        amenities = set_amenities_for_room(row, data, row_index)
        room = create_room(room_type, name, floor, scores, amenities, online_sell,
          observations, minimum_rate, row_index)
        set_room_accommodations(row, data, room, row_index)
      end
        
      message_struct
    end

    private
    
    def set_amenities_for_room(row, data, row_index)
      amenity_ids = (amenities_range).map do |header_index|
        if row[header_index].downcase == 'si' 
          get_amenity(header_index, data, row_index)
        end
      end
      
      amenity_ids.compact
    end
    
    def amenities_range
      @amenities_range ||= (23..39)
    end
    
    def get_amenity(index, data, row_index)
      name = data.headers[index].gsub('_', ' ').capitalize
      
      amenity = Amenity.find_or_initialize_by(name: name, kind: :room, name_en: name)
      
      return amenity.id if amenity.persisted?
      
      if amenity.save
        amenity.id
      else
      message_struct << amenity.errors.full_messages.join(', ') + " on row #{row_index}"
      end
    end

    def get_room_type(room_type_name, index, category)
      room_type = hotel.room_types.find_or_initialize_by(name: room_type_name, category: category)

      return room_type if room_type.persisted?

      if room_type.save
        room_type
      else
        message_struct << room_type.errors.full_messages.join(', ') + " on row #{index}"
      end
    end

    def create_room(room_type, name, floor, scores, amenities, online_sell, observations,
      minimum_rate, index)
      room = Room.find_or_initialize_by(room_type: room_type, name: name,
        floor: floor, scores: scores, amenities: amenities, online_sell: online_sell,
        observations: observations, minimum_rate: minimum_rate)

      return room if room.persisted?

      if room.save
        room
      else
        message_struct << room.errors.full_messages.join(', ') + " on row #{index}"
      end
    end

    def set_room_accommodations(row, data, room, row_index)
      (accommodations_names_range).each do |header_idx|
        quantity = row[header_idx].to_i  

        if quantity > 0
          accommodation = get_accommodation(header_idx, data, row_index)
          create_rooms_accommodation(room.id, accommodation.id, quantity, row_index)
        end
      end
    end
  
    def accommodations_names_range
      @accommodations_names_range ||= 6..11
    end
  
    def get_accommodation(header_index, data, row_index)
      name = data.headers[header_index].capitalize
      
      accommodation = Accommodation.find_or_initialize_by(name: name, name_en: '')
      
      binding.pry
      return accommodation if accommodation.persisted?
      
      if accommodation.save
        accommodation
      else
        message_struct << accommodation.errors.full_messages.join(', ') + " on row #{row_index}"
      end
    end
  
    def create_rooms_accommodation(room_id, accommodation_id, quantity, index)
      room_accommodation = RoomAccommodation.find_or_initialize_by(room_id: room_id,
        accommodation_id: accommodation_id, quantity: quantity)
        
      return if room_accommodation.persisted?
      
      if room_accommodation.save
        room_accommodation
      else
        message_struct << room_accommodation.errors.full_messages.join(', ') + " on row #{index}"
      end
    end
  end
end
