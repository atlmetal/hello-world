show.hatml.haml
en linea 40:  %button.nav-link.navbar-btn.btn-lg#accommodation-button{ 'data-toggle': 'tab', href: '#room_accommodations', role: 'tab' }

ultimas filas

      .save-accommodation-file.hide
        = form_with url: add_accommodation_mapping_admin_hotel_path, method: :post, id: 'accommodation-file-form', multipart: true do |f|
          = file_field_tag :accommodation_file, 'data-input' => 'false', class: 'form-control filestyle hotel-accommodation-mapping', required: false, accept: 'text/csv', 'data-buttonText' => 'Cargue de acomodación'
          %a
            = link_to 'Template', "https://docs.google.com/spreadsheets/d/1yHsLiL5zJubbTARddxrlZgzueph_pstS0b0W8ej14FI/edit#gid=0", id: 'accommodation-template', target: '_blank'
            
            
show.scss

14 a 30

  .container-hotel-buttons {
    position: fixed;
    background: #edf0f4;
    padding: 15px;
    bottom: 0;
    right: 0;
    width: calc(100% - 16em);
    display: flex;
    justify-content: space-between;
    flex-direction: row-reverse;

    .btn {
      height: 40px;
      width: min-content;
      font-weight: bold;
      font-size: 14px;
    }

hotel_config.js

$(function() {
  $('.hotel-accommodation-mapping').on('change', function(e) {
    var getExt = this.files[0].name.split('.').reverse()[0].toLowerCase();
    $('.box-ajax-gif-full-view').show();

    if (getExt != 'csv') {
      sweetAlert({
        type: 'warning',
        title: 'Error',
        text: 'Sólo se permiten archivos con extensión .csv',
        showCancelButton: true
      });
      $('.box-ajax-gif-full-view').hide();
    } else {
      $('#accommodation-file-form').trigger('submit.rails');
    }
  });

  $(document).on('show.bs.tab', '.container-tabs-bar button', function(e) {
    var getAccommodationFile = $('.save-accommodation-file');

    if ($(e.target).is('#accommodation-button')) {
      getAccommodationFile.removeClass('hide');
    } else {
      getAccommodationFile.addClass('hide');
    }
  });
});


hotel_contrroler.rb

    flash[:important_alert] = unless response.empty?
      "Se presentaron los siguientes problemas: <br> #{response.join("<br>")}"
    else
      'Inventario actualizado'
    end

    flash[:important_alert] = if !response.empty?
      'Inventario actualizado'
    else
      "Se presentaron los siguientes problemas: <br> #{response.join("<br>")}"
    end
