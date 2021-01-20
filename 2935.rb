  require 'active_record_extend'
  
  scope :search_query, ->(query) {
    guest_table = Guest.arel_table
    phone_table = Phone.arel_table

    select(:id, :full_name, :email, :country, :address,
      :phone_id, :'phones.number', :'phones.area_code', :'phones.iso_code',
      :identification_number, :email).
    joins(:phone).includes(:phone).
    where(
      ActiveRecordExtend.remove_accent('guests.full_name').matches(
        ActiveRecordExtend.remove_accent("'%#{query}%'")
      ).
      or(guest_table[:identification_number].matches("%#{query}%")).
      or(guest_table[:email].matches(ActiveRecordExtend.remove_accent("'%#{query}%'"))).
      or(phone_table[:number].matches("%#{query}%"))
    ).
    decorate.
    uniq { |guest| [guest.phone_id, guest.full_name, guest.email] }
  }
