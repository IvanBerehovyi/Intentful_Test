# frozen_string_literal: true

require_relative '../custom_exceptions/resolution_validation_error'
module Services
  class InterfulService
    include Modules::Validator
    URL_TEMPLATE = 'https://www.smashingmagazine.com/#first_date#/desktop-wallpaper-calendars-#second_date#/'

    def run
      begin
        params
        validate_params
        Services::SaveService.new(url, params).call
      rescue OpenURI::HTTPError
        p 'There is no site with these parameters.'
      rescue CustomExceptions::ResolutionValidationError => e
        p e.message
      rescue CustomExceptions::UploadImageError => e
        p e.message
      rescue CustomExceptions::YearValidationError => e
        p e.message
      rescue Date::Error
        p 'You entered the wrong date. Try in the format 072023 where first is the month then the year.'
      rescue StandardError => e
        p e
      end

    end

    private

    def params
      @params ||= Optimist.options do
        opt :month, 'month', type: :string
        opt :resolution, 'resolution', type: :string
      end
    end

    def url
      url_from_date(date_hash(params[:month]))
    end

    def url_from_date(date)
      URL_TEMPLATE.gsub('#first_date#', date[:second_url_date]).gsub('#second_date#', date[:first_url_date])
    end

    def date_hash(month_year)
      parsed_date = Date.strptime(month_year, '%m%Y')

      {
        first_url_date: parsed_date.strftime('%B-%Y').downcase,
        second_url_date: parsed_date.prev_month.strftime('%Y/%m')
      }
    end
  end
end
