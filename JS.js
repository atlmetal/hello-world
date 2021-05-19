function checkAndHideCarouselControls(e) {
  var container = $(e.target).parents('.container-photos-control').prev();
  var button = $(e.currentTarget);
  var runner = container.find('ul');
  var liWidth = runner.find('li:first').outerWidth();
  var itemsPerPage = 4;
  var numberOfItems = runner.find('li').length;

  runner.width(numberOfItems * liWidth);

  if (button.is('.right')) {
    $(runner).animate({ 'left': '-=150px' }, 'slow');
  } else if (button.is('.left')) {
    $(runner).animate({ 'left': '+=150px' }, 'slow');
  };
}

function showExtraBedInputs(event) {
  var value = $(event.target).val();

  if (value === 'true') {
    $(event.target).offsetParent().siblings().removeClass('hide');
  } else {
    $(event.target).offsetParent().siblings().addClass('hide');
  }
}

function changeBackgroundWhite(element) {
  $(element).find('.accommodation-label').css('background', 'white');
}

function checkTargetInputs(e, insertedItem, originalEvent) {
  var parent;

  if ($(originalEvent.target.offsetParent).hasClass('extra-bed')) {
    parent = $(originalEvent.target).parents('.third');
    changeBackgroundWhite(insertedItem);
  } else {
    parent = $(originalEvent.target).parents('.second');
  }

  var targetSelect = parent.find('.new-room-accommodation-select').find('select option:selected');
  var targetQuantity = parent.find('.accommodation-quantity').find('input');

  $(insertedItem).find('.accommodation-id > select').val(targetSelect.val()).trigger('select');
  $(insertedItem).find('.accommodation-label').text(targetSelect.text());
  $(insertedItem).find('.room-accommodation-quantity').val(targetQuantity.val());
}

$(document).on('click', '.photos-controls', checkAndHideCarouselControls);
$(document).on('change', '.extra-accommodation-select', showExtraBedInputs);
$(document).on('cocoon:after-insert', '.room-accommodations-form', checkTargetInputs);

$(function() {
  Array.from($('.carousel-room-type-photos')).forEach(function(carousel) {
    var runner = $(carousel).find('ul');
    var numberOfItems = runner.find('li').length;
    var liWidth = runner.find('li:first').outerWidth();
    var itemsPerPage = 4;

    runner.width(numberOfItems * liWidth);
  });

  Array.from($('.room-accommodation-item')).forEach(function(accommodationElement) {
    var select = $(accommodationElement).children().find('.extra-accommodation-select option:selected');

    if (select.val() === 'true') {
      changeBackgroundWhite(accommodationElement);
    }
  });

  $('.commissions-date').datepicker({
    format: 'yyyy-mm-dd'
  });
});

$(document).on('cocoon:before-insert', '#hotel-tiered-commission-form', function (e, insertedItem) {
  insertedItem.find('.commissions-date').datepicker({
    format: 'yyyy-mm-dd'
  });
});

$(document).on('cocoon:before-remove', '.container-room_type-rooms', function (e, removedItem) {
  removedItem.next('.add-room-btn').hide()
});

var cocoonTargets = ".nav-item > .nav-link:contains('Accommodations'), .add-room-button, .add-room-accommodation";

$(document).on('click', cocoonTargets, function() {
  $('.add-room-accommodation a').
    data('association-insertion-method', 'append').
    data('association-insertion-node', function(link) {
      return link.closest('.accommodation-item').parent().parent().next();
    });
});

$(function() {
  $('.hotel-accommodation-mapping').on('change', function(e) {
    var getExt = this.files[0].name.split('.').reverse()[0].toLowerCase();
    $('.box-ajax-gif-full-view').show();

    if (getExt != 'csv') {
      $('.box-ajax-gif-full-view').hide();
      sweetAlert({
        type: 'warning',
        title: 'Error',
        text: 'Sólo se permiten archivos con extensión .csv',
        showCancelButton: true
      });
    } else {
      $('#send_accommodation_file').trigger('click');
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
