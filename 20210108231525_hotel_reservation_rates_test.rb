/home/mateo/Ayenda/ayenda/db/migrate/20210108231525_hotel_reservation_rates_test.rb

class HotelReservationRatesTest < ActiveRecord::Migration[6.0]
  def change
    create_table :hotel_reservation_rates_tests do |t|
      t.references :hotel_reservation, index: true, foreign_key: true, null: false
      t.references :room_type_rates_test, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
