# frozen_string_literal: true

require_relative '../modules/validator'
require_relative '../servises/interful_service'
require 'optimist'

RSpec.describe Services::InterfulService do
  let(:interful_service) { Services::InterfulService.new }

  describe '#url_from_date' do
    it 'returns a valid URL' do
      date_hash = { first_url_date: '2023/06', second_url_date: 'july-2023' }
      expect(interful_service.send(:url_from_date, date_hash)).to eq('https://www.smashingmagazine.com/july-2023/desktop-wallpaper-calendars-2023/06/')
    end
  end

  describe 'invalid_params' do
    it 'returns a invalid params' do
      params = { help: false, month: nil, resolution: nil }
      expect(interful_service.send(:params)).to eq(params)
    end
  end
end

