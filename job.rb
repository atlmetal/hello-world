module Hotels
  class AddAccommodationsJob < ApplicationJob
    queue_as :low

    def perform(hotel, user, identifier)
      get_s3_file(identifier)
      response = ::Hotels::AddAccommodationMappingService.call(@csv_file, hotel)
      message = response.message_errors.join('<br>')
      message_email = message.empty? ? 'Everything went fine!' : message

      SendgridAdapter.send_accommodation_mapping(user.email, hotel.name, response.status,
        Date.current, message_email)

      delete_s3_file(identifier)
    end

    private

    def s3_connection
      @s3_connection ||= Aws::S3::Client.new(region: Figaro.env.aws_backups_region,
        access_key_id: Rails.application.credentials.aws.dig(:ayenda, :access_key_id),
        secret_access_key: Rails.application.credentials.aws.dig(:ayenda, :secret_access_key))
    end

    def get_s3_file(identifier)
      response = s3_connection.get_object(bucket: Rules.aws_buckets['files'], key: "csv_accommodation_s3_#{identifier}")
      @csv_file = response.body.read
    end

    def delete_s3_file(identifier)
      s3_connection.delete_object(bucket: Rules.aws_buckets['files'], key: "csv_accommodation_s3_#{identifier}")
    end
  end
end
