remote_ayenda_cash_discounts.rb  #(servicio creado para utilziarse en el reservations_controller.rb)
El cual era llamado en la linea 234 ::Reservations::RemoveAyendaCashDiscounts.call(@reservation)


module Reservations
  class RemoveAyendaCashDiscounts < ApplicationService
    attr_reader :reservation

    def initialize(reservation)
      @reservation = reservation
    end

    def call
      if valid_for_remove_ayenda_cash_discount?
        reservation.reservation_discounts.ayenda_cash.destroy_all
      end
    end

    private

    def valid_for_remove_ayenda_cash_discount?
      !reservation.ayenda_cash_used? && reservation.reservation_discounts.ayenda_cash.any? &&
        reservation.valid?
    end
  end
end
