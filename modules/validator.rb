# frozen_string_literal: true

require_relative '../custom_exceptions/resolution_validation_error'
module Modules
  module Validator
    DATE_PARAM_COUNT = 6
    MONTH_PARAM_COUNT = 2
    YEAR_PARAM_COUNT = 4

    def validate_params
      validate_date
      validate_resolution
    end

    def validate_month_param_length
      month_year.length == 6
    end

    def validate_month_param_month
      month = month_year[0..1]
      raise CustomExceptions::MonthValidationError, 'Invalid month specified.' unless month.length == MONTH_PARAM_COUNT

      Date.strptime(month, '%m')
    end

    def validate_month_param_year
      year = month_year[2..5]
      raise CustomExceptions::YearValidationError, 'The year is incorrect. The year must be in the format 2023' unless year.length == YEAR_PARAM_COUNT

      Date.strptime(year, '%Y')
    end

    def validate_resolution
      resolution_pattern = /^\d{1,4}x\d{1,5}$/
      unless resolution =~ resolution_pattern
        raise CustomExceptions::ResolutionValidationError, 'No images were found for these parameters, try another parameters.'
      end

    end

    private

    def month_year
      @month_year ||= params[:month]
    end

    def resolution
      @resolution ||= params[:resolution]
    end

    def validate_date
      validate_month_param_length
      validate_month_param_month
      validate_month_param_year
    end
  end
end
