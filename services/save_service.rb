# frozen_string_literal: true

require_relative '../custom_exceptions/resolution_validation_error'

module Services
  class SaveService
    def initialize(url, params)
      @url = url
      @params = params
    end

    def call
      save
    end

    private

    attr_reader :params

    def save
      folder_name = "images/#{params[:month]}_#{params[:resolution]}"
      resources = Services::ParserService.new(@url, params[:resolution]).call
      raise CustomExceptions::UploadImageError, 'No images were found for these parameters, try another format.' if resources.empty?

      save_resources(resources, folder_name)
      p 'Congratulations! You have successfully uploaded pictures.'
    end

    def save_resource(url, folder_name)
      URI.open(url) do |resource|
        name = url.match(/[^\/]*\.\w+$/)
        file_path = File.join(folder_name, name[0])
        File.open(file_path, "wb") do |file|
          file.write(resource.read)
        end
      end
    end

    def save_resources(urls, folder_name)
      FileUtils.mkdir_p(folder_name) unless Dir.exist?(folder_name)

      urls.each do |url|
        save_resource(url, folder_name)
      end
    end
  end
end
