Del /app/views/admin/reservations/     _guest.html.haml
  linea 40 quitar el hide
  
Del  /app/views/admin/reservations/    _form.html.haml
  linea 16 cambia de: = f.hidden_field :ayenda_cash_used, value: false, id: :'used-ayenda-cash'
  a:                  = f.hidden_field :ayenda_cash_used, value: @reservation.ayenda_cash_used , id: :'used-ayenda-cash'

Del   app/javascript/packs/admin_form/        index.js
  Linea 22 se reubica:   if (form.id !== 'edit_reservation') {
    queda asi
   
   setIntlTelInputValues(form);
  initializeApplyAyendaCashListener(form);
  if (form.id !== 'edit_reservation') {
    initializeCouponListeners(form);
    
 Del /app/controllers/admin/         reservations_controller.rb
  Lineas 233
     rooms_for_destruction = @reservation.booking_rooms.select { |b| b.room if b.marked_for_destruction? }
             reservations RemoveAyendaCashDisctounts.call@(reservation)
              if reservations.ayenda_cash_used
              #eliminar los descuenots de ayenda cash (esto es els codigo a revisar del servicio como base)
    ::Reservations::CalculateAndAssignValuesService.call(@reservation)
