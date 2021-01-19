/home/mateo/Ayenda/ayenda/db/migrate/20210108222402_room_type_rates_test.rb

class RoomTypeRatesTest < ActiveRecord::Migration[6.0]
  def change
    create_table :room_type_rates_tests do |t|
      t.references :room_type, index: true, foreign_key: true, null: false
      t.date :date, null: false
      t.integer :person_number, default: 0, null: false
      t.integer :kind, limit: 1, default: 0, null: false
      t.boolean :is_edited, default: 0
      t.boolean :with_variable_rates, default: 0
      t.decimal :rate_increase_value, :decimal, default: 0
      t.integer :client_type_enum
      t.jsonb :variation_rates
      t.jsonb :pax_rates
      t.timestamps null: false
    end
    add_index :room_type_rates_tests, [:room_type_id, :date, :person_number, :kind], unique: true,
          name: :index_rates_room_type_test_date_person_number_kind
  end
end