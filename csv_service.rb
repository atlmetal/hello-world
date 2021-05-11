  module Hotels
  class AddAccommodationMappingService < ApplicationService
    attr_reader :accommodation_file, :hotel, :message_errors, :data

    def initialize(accommodation_file, hotel)
      @accommodation_file = accommodation_file
      @hotel = hotel
      @data = reader_csv_file(accommodation_file)
      @message_errors = []
    end

    def call
      data.each.with_index(2) do |row, row_index|
        name = row['número_habitación'].to_s

        if name.empty?
          message_errors << "Field room number is empty on row #{row_index}"
          next
        end

        category = row['categoría']&.downcase
        room_type_name = row['acomodación'].to_s.capitalize
        room_type = get_room_type(room_type_name, row_index, category)
        next unless room_type

        minimum_rate = row['tarifa_mínima'].to_d
        floor = row['número_de_piso'].to_i
        quantity_extra_bed = row['cantidad_extra_bed'].to_i
        kind_extra_bed = row['tipo_extra_bed'].to_s
        observations = row['observaciones'].to_s

        amenities = set_amenities_for_room(row, data, row_index)
        room = create_room(room_type, name, floor, amenities, observations, minimum_rate, row_index)

        if room
          set_room_accommodations(row, data, room, row_index)
          create_extra_bed(quantity_extra_bed, kind_extra_bed, row_index, room)
        end
      end

      message_errors
    end

    private

    def reader_csv_file(file)
      converter = lambda { |header| header.downcase }
      CSV.parse(File.read(file), headers: true, header_converters: converter)
    end

    def handle_creation_errors(object, index)
      return object if object.persisted?

      error = object.errors.full_messages.join(', ') + " on row #{index}, model #{object.class.to_s}"
      message_errors << error unless message_errors.include?(error)
      nil
    end

    def amenity
      @amenity ||= Amenity.all
    end

    def get_amenity(amenity_index, data, row_index)
      name = data.headers[amenity_index].gsub('_', ' ').capitalize
      name_en = I18n.t("models.amenities.#{name.downcase}", locale: :en)

      amenity = @amenity.find_or_create_by(name: name, kind: :room, name_en: name_en)

      object = handle_creation_errors(amenity, row_index)
      object&.id
    end

    def amenities_range
      @amenities_range ||= (14..30)
    end

    def set_amenities_for_room(row, data, row_index)
      amenity_ids = amenities_range.map do |header_index|
        get_amenity(header_index, data, row_index) if row[header_index].to_s.downcase == 'si'
      end

      amenity_ids.compact
    end

    def room_types
      @room_types ||= hotel.room_types
    end

    def get_room_type(room_type_name, index, category)
      room_type_category = RoomType.categories[category]
      room_type = @room_types.find_or_create_by(name: room_type_name,
        category: room_type_category, distribution_sales: true)

      handle_creation_errors(room_type, index)
    end

    def rooms
      @rooms ||= Room.all
    end

    def create_room(room_type, name, floor, amenities, observations, minimum_rate, index)
      room = @rooms.find_or_create_by(room_type: room_type, name: name, floor: floor,
        amenities: amenities, observations: observations, minimum_rate: minimum_rate)

      handle_creation_errors(room, index)
    end

    def accommodations
      @accommodations ||= Accommodation.all
    end

    def get_accommodation(row_index:, header_index: nil, data: nil, name: nil, is_extra: false)
      name = name || data.headers[header_index]&.capitalize
      name_en = I18n.t("models.accommodation.#{name.downcase}", locale: :en)
      accommodation = @accommodations.find_or_create_by(name: name, name_en: name_en,
        is_extra: is_extra)

      handle_creation_errors(accommodation, row_index)
    end

    def room_accommodations
      @room_accommodations ||= RoomAccommodation.all
    end

    def create_rooms_accommodation(room_id, accommodation_id, quantity, index)
      room_accommodation = @room_accommodations.find_or_create_by(room_id: room_id,
        accommodation_id: accommodation_id, quantity: quantity)

      handle_creation_errors(room_accommodation, index)
    end

    def accommodations_names_range
      @accommodations_names_range ||= (6..11)
    end

    def set_room_accommodations(row, data, room, row_index)
      accommodations_names_range.each do |header_index|
        quantity = row[header_index].to_i

        if quantity > 0 && get_accommodation(row_index: row_index, header_index: header_index, data: data)
          create_rooms_accommodation(room.id, accommodation.id, quantity, row_index)
        end
      end
    end

    def create_extra_bed(quantity, kind_accommodation, index, room)
      if quantity > 0 && get_accommodation(row_index: index, name: kind_accommodation, is_extra: true)
        create_rooms_accommodation(room.id, accommodation.id, quantity, index)
      end
    end
  end
end
