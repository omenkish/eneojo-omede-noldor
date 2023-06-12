# frozen_string_literal: true

RSpec.describe Noldor::Http::Request do
  describe '#send_http' do
    let(:params) { { method: 'GET', path: 'book' } }

    context 'when credentials is not set' do
      it { expect { described_class.instance.send_http(**params) }.to raise_error(Noldor::Exceptions::InvalidRequest, 'Please provide a valid api key') }
    end

    context 'when credentials is set' do
      context 'when request is successful' do
        before do
          Noldor.credentials.api_key = 'hello there'

          fixture_base_path = File.join('spec', 'fixtures', 'noldor', 'resources')
          fixture_file_path = File.join(fixture_base_path, 'success.json')
          response = File.read(fixture_file_path)

          WebMock
            .stub_request(:get, 'https://test-the-one-api.dev/book')
            .to_return(body: response, status: 200)
        end

        it 'returns a valid book object' do
          res = described_class.instance.send_http(**params)

          expect(res[:data].data.first.name).to eq('The Lord of the Rings Series')
        end
      end

      context 'with 400 status code' do
        before do
          Noldor.credentials.api_key = 'hello there'

          WebMock
            .stub_request(:get, 'https://test-the-one-api.dev/book')
            .to_return(body: '', status: 400)
        end

        it {
          expect { described_class.instance.send_http(**params) }.to raise_error(Noldor::Exceptions::InvalidRequest, 'Invalid request, status code: 400')
        }
      end

      context 'with invalid url' do
        let(:params) { { method: 'GET', path: Noldor } }

        it {
          expect { described_class.instance.send_http(**params) }
            .to raise_error(ArgumentError, 'Invalid url format')
        }
      end
    end
  end
end
