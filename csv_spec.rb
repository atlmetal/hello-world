require 'rails_helper'

RSpec.describe Hotels::AddAccommodationMappingService, type: :service do
  # room & room_accommodation need to be created
  let!(:hotel) { create(hotel: :with_dependencies, default_room: false, quantity_room_types: 4, name: 'Hotel California') }
  let(:header) { 'NÚMERO_HABITACIÓN,TARIFA_MÍNIMA,TIPO,ACOMODACIÓN,CATEGORÍA,Sencilla,Semidoble,Doble,Camarote,Queen,King,CAMAS_ADICIONALES_X_HABITACIÓN_(Cantidad),TIPO_DE_CAMA(S)_ADICIONAL(ES)_X_HABITACIÓN_(Según_medidas),ESTADO_DE_LA_PINTURA,SÁBANAS_BLANCAS,TV,ESTADO_DEL_COLCHÓN,BAÑO_INDEPENDIENTE,AGUA_CORRIENTE,ENERGÍA,ESTADO_GENERAL,¿Comercializable?,TOALLAS_DE_CUERPO,TOALLAS_DE_MANO,VENTILACIÓN,MESA_DE_NOCHE,BALCÓN,VENTILADOR,VENTANA_A_LA_CALLE,AIRE_ACONDICIONADO,JACUZZI,BAÑERA,ESCRITORIO,SOFÁ,SOFÁ-CAMA,COCINETA,NEVERA,MINIBAR,CLOSET,Observaciones' }
  # Best one input data from csv
  let(:row_one) { '101,100000,Habitación,Sencilla,Suite,1,1,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,hola mundo' }
  # Wrong room number and it gets insted 0 and it creates a new room!
  let(:row_two) { 'a101a,100000,Habitación,Sencilla,Suite,1,1,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,hola mundo' }
  # Wrong acomodation, it gets nil and it doesn't create a new room
  let(:row_three) { '102,100000,Habitación,Sencilla1,Suite,1,1,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,hola mundo' }
  let(:row_four) { '101,100000,Habitación,Sencilla,Suite,1,hola,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,si,hola mundo'}
  let(:rows) { [header, row_one, row_two] }
  let!(:room_types) { hotel.room_types } ???????????????
  # let!(:accommodation_ids) { Accommodation.ids }

  describe '#call' do
    it 'read and save each data from column & row' do
      binding.pry
      expect(var.values).to all(be_between(0,50))

      expect(name).not_to be_empty
      expect(minimum_rate).not_to be_empty
      expect(room_type).not_to be_empty
      expect(categoria).not_to be_empty
      expect(floor).not_to be_empty
      expect(online_sell).not_to be_empty
      expect(observations).not_to be_empty
      expect(scores).not_to be_empty
    end
  end
end
