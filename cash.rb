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

                
 Del       /app/controllers/reservations_controller.rb
                
     Se arregla cagada de Juanfer 
                @currency_settings = Rules.currencies[@hotel.currency]
                
                Entre el   ) y el ELSE

    
    
    
    
    Del index se habia hecho esto y luesgo del feedback Esteban lo replanteo con lo de arriba
    
        // form.addEventListener('click', ({ target }) => {
    //   if (target.classList.contains('remove-ayenda-cash') || target.parentNode.classList.contains('remove-ayenda-cash')) {
    //     console.log("Hola mundo 3.0")
    //     const usedAyendaCash = document.getElementById('used-ayenda-cash')
    //     usedAyendaCash.value = false
    //     const ayendaCashForm = document.getElementById('ayenda_cash_form')
    //     ayendaCashForm.style.display = "none";
    //   }
    // });

    // form.addEventListener('click', ({ target }) => {
    //   if (target.classList.contains('active-ayenda-cash') || target.parentNode.classList.contains('active-ayenda-cash')) {
    //     console.log("Hola mundo 4.0")
    //     const usedAyendaCash = document.getElementById('used-ayenda-cash')
    //     usedAyendaCash.value = false
    //     const ayendaCashForm = document.getElementById('ayenda_cash_form')
    //     ayendaCashForm.style.display = "none";
    //   }
    // });
