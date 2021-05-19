module Hotels
  class UploadAccommodationFileService < ApplicationService
    attr_reader :accommodation_file

    def initialize(accommodation_file)
      @accommodation_file = accommodation_file
    end

    def call
      upload_file_to_s3
    end

    private

    def upload_file_to_s3
      s3 = Aws::S3::Resource.new(
        region: Figaro.env.aws_viajala_region,
        access_key_id: Rails.application.credentials.dig(:aws, :viajala, :access_key_id),
        secret_access_key: Rails.application.credentials.dig(:aws, :viajala, :secret_access_key)
      )
      bucket = s3.bucket('exports-files')

      bucket.object('csv_accommodation_s3').upload_file(accommodation_file)
    end
  end
end


WHILE CONTROLLER

  def add_accommodation_mapping
    accommodation_file = params[:accommodation_file]
    ::Hotels::UploadAccommodationFileService.call(accommodation_file)
    ::Hotels::AddAccommodationsJob.perform_later(@hotel, current_user)
    flash[:important_alert] = 'In five minutes you will get an answer to the email'

    redirect_to admin_hotel_path(@hotel)
  end
