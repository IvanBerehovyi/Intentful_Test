# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module Services
  class ParserService
    def initialize(url, resolution)
      @url = url
      @resolution = resolution
    end

    def parse_html
      parsed_html = Nokogiri::HTML(URI.open(@url))
      resources = parsed_html.css("a:contains(\"#{@resolution}\")")
      resources.map { |element| element[:href] }
    end
  end
end
