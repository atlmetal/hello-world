module Hotels
  class AddAccommodationMappingService < ApplicationService
    attr_reader :accommodation_file, :hotel

    def initialize(accommodation_file, user, hotel)
      @accommodation_file = accommodation_file
      @user = user
      @hotel = hotel
    end

    def call
      converter = lambda { |header| header.downcase }
      data = CSV.parse(File.read(accommodation_file), headers: true, header_converters: converter)

      data.each_with_index do |row, index|
        name = row['número_habitación'].to_s
        minimum_rate = row['tarifa_mínima'].to_d
        room_type = row['acomodación'].to_s
        categoria = row['categoría'].to_s
        floor = row['número_de_piso'].to_i
        online_sell = row['¿comercializable?'].to_s.empty?
        observations = row['observaciones'].to_s
        scores = {
          tv: row['tv'].to_i,
          paint: row['estado_de_la_pintura'].to_i,
          water: row['agua_corriente'].to_i,
          bathroom: row['baño_independiente'].to_i,
          mattress: row['estado_del_colchón'].to_i,
          electricity: row['energía'].to_i,
          blankets: row['sábanas_blancas'].to_i,
          overall_state: row['estado_general'].to_i
        }

        amenities = set_amenities_for_room(row, data)
        binding.pry
        room = create_rooms(room_type, name, floor, scores, !online_sell, amenities, observations, minimum_rate)
        set_bed_quantiy_for_room(row, data, room)
        # binding.pry
      end
    end

    private

    def create_rooms(room_type, name, floor, scores, online_sell, amenities, observations, minimum_rate)
      room_type_object = @hotel.room_types.find_by(name: room_type)
      room = Room.new(room_type: room_type_object, name: name, floor: floor, scores: scores, online_sell: online_sell, amenities: amenities, observations: observations, minimum_rate: minimum_rate)
      room.save if room_type_object
      
      room
    end

    def create_rooms_accommodation(room, accommodation, quantity)
      room_accommodation = RoomAccommodation.new(room_id: room.id, accommodation_id: accommodation.id, quantity: quantity)
      room_accommodation.save
    end

    def set_amenities_for_room(row, data)
      amenities = []

      (23..39).each do |index|
        amenities << get_amenities_id(index, data) if row[index] == 'si'
      end
      
      amenities
    end

    def get_amenities_id(index, data)
      name = data.headers[index].gsub('_', ' ').capitalize
      Amenity.find_by(name: name.strip).id.to_s
    end

    def set_bed_quantiy_for_room(row, data, room)
      (7..12).each do |index|
        accommodation = get_accommodation(index, data)
        quantity = row[index].to_i
        create_rooms_accommodation(room, accommodation, quantity) if quantity > 0 && accommodation
      end
    end

    def get_accommodation(index, data)
      name = data.headers[index].capitalize
      Accommodation.find_by(name: name.strip)
    end
  end
end


  #   room.save!
        
  #   room
  # rescue => e
  #   binding.pry
  #   message_struct << e.message + " room, on row #{index}"
