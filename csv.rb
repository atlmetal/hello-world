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
        idx = index + 2
        name = row['número_habitación'].to_s
        minimum_rate = row['tarifa_mínima'].to_d
        room_type = row['acomodación'].to_s
        categoria = row['categoría'].downcase.to_sym
        floor = row['número_de_piso'].to_i
        marketable = row['¿comercializable?'].to_s
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

        if name.empty?
          # llevar conteo de cuantas no skipeadas?
          validate_room_name(idx)
          next
        end

        amenities = set_amenities_for_room(row, data)
        online_sell = marketable == 'si'
        room = create_rooms(room_type, name, floor, scores, amenities, online_sell,
          observations, minimum_rate, idx, categoria)
        set_room_accommodations(row, data, room, idx)
        # binding.pry
      end

      message_struct
    end

    private

    def create_rooms(room_type, name, floor, scores, amenities, online_sell, observations,
      minimum_rate, index, categoria)
      room_type_object = get_room_type(room_type, index, categoria)
      # binding.pry
      return unless room_type_object

      room = Room.find_or_initialize_by(room_type: room_type_object, name: name, floor: floor,
        scores: scores, amenities: amenities, online_sell: online_sell,
        observations: observations, minimum_rate: minimum_rate)

      return room if room.persisted?
      
      room.valid?
      if room.save
        room
      else
        message_struct << room.errors.full_messages.join(', ') + " on row #{index}"
      end
    end

    def create_rooms_accommodation(room_id, accommodation_id, quantity, index)
      begin
        room_accommodation = RoomAccommodation.find_or_initialize_by(room_id: room_id,
          accommodation_id: accommodation_id, quantity: quantity)

        return if room_accommodation.persisted?

        room_accommodation.save!
      rescue => e
        message_struct << e.message + " room_accommodation, on row #{index}"
      end
    end

    def set_amenities_for_room(row, data)
      amenities = []

      (23..39).each do |index|
        amenity = get_amenity(index, data)
        amenities << amenity if row[index] == 'si' && amenity
      end

      amenities
    end

    def get_amenity(index, data)
      begin
        name = data.headers[index].gsub('_', ' ').capitalize
        amenity = Amenity.find_by(name: name).id.to_s
      rescue => e
        error = "Amenity #{name} does not exist on AOS"
        message_struct << error unless message_struct.include?(error)
      end

      amenity unless error
    end

    def set_room_accommodations(row, data, room, idx)
      (7..12).each do |index|
        accommodation_id = get_accommodation(index, data)
        quantity = row[index].to_i
        create_rooms_accommodation(room.id, accommodation_id, quantity, idx) if quantity > 0 && accommodation_id
      end
    end

    def get_accommodation(index, data)
      begin
        name = data.headers[index].capitalize
        accommodation_id = Accommodation.find_by(name: name).id
      rescue => e
        error = "Accommodation #{name} does not exist on AOS"
        message_struct << error unless message_struct.include?(error)
      end

      accommodation_id unless error
    end

    def validate_room_name(index)
      error = "Field room number is empty on row #{index}"
      message_struct << error
    end
    
    def get_room_type(room_type, index, categoria)
      room_type_object = hotel.room_types.where(category: categoria).find_by(name: room_type)

      if room_type_object.nil?
        error = "Field accommodation is not valid on row #{index}"
        message_struct << error
      end

      room_type_object
    end
  end
end
