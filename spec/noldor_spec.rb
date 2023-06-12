# frozen_string_literal: true

RSpec.describe Noldor do
  after { described_class.credentials.api_key = '' }

  it 'has a version number' do
    expect(Noldor::VERSION).not_to be nil
  end

  describe '#credentials' do
    context 'when credentials is not set' do
      it 'returns default values for credential' do
        expect(described_class.credentials.api_key).to eq('')
        expect(described_class.credentials.exception_enabled).to eq(true)
        expect(described_class.credentials.api_base).to eq('https://test-the-one-api.dev')
      end
    end

    context 'when credentials is set' do
      it 'returns the api key' do
        described_class.credentials.api_key = 'hello there'
        expect(described_class.credentials.api_key).to eq('hello there')
      end
    end
  end

  describe '#configure' do
    context 'when configure is called without passing a block' do
      it { expect{ described_class.configure }.to raise_error(RuntimeError, 'Expected a block to be passed in') }
    end

    context 'when a block is passed' do
      it 'returns the set credentials' do
        described_class.configure do |config|
          config.api_key = 'new key'
          config.exception_enabled = false
        end

        expect(described_class.credentials.api_key).to eq('new key')
        expect(described_class.credentials.exception_enabled).to eq(false)
      end
    end
  end
end
