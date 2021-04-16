require 'rails-helper'

RSpec.describe Hotels::AddAccommodationMappingService, type: :service do
  # room & room_accommodation need to be created
  let(:header) { 'NÚMERO_HABITACIÓN,TARIFA_MÍNIMA,TIPO,ACOMODACIÓN,CATEGORÍA,Sencilla,Semidoble,Doble,Camarote,Queen,King,CAMAS_ADICIONALES_X_HABITACIÓN_(Cantidad),TIPO_DE_CAMA(S)_ADICIONAL(ES)_X_HABITACIÓN_(Según_medidas),ESTADO_DE_LA_PINTURA,SÁBANAS_BLANCAS,TV,ESTADO_DEL_COLCHÓN,BAÑO_INDEPENDIENTE,AGUA_CORRIENTE,ENERGÍA,ESTADO_GENERAL,¿Comercializable?,TOALLAS_DE_CUERPO,TOALLAS_DE_MANO,VENTILACIÓN,MESA_DE_NOCHE,BALCÓN,VENTILADOR,VENTANA_A_LA_CALLE,AIRE_ACONDICIONADO,JACUZZI,BAÑERA,ESCRITORIO,SOFÁ,SOFÁ-CAMA,COCINETA,NEVERA,MINIBAR,CLOSET,Observaciones' }
  let(:rows) { [header] }
  let!(:accommodation_ids) { Accommodation.ids }
  # So what that means is that if you call let multiple times in the same example, it evaluates the let block just once (the first time it’s called).
  let
  # You can use let! to force the method’s invocation before each example.
  let!
  # The difference between let, and let! is that let! is called in an implicit before block. So the result is evaluated and cached before the it block.
  describe '#call' do
  end
  
  it 'read and save each data from column & row' do
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
