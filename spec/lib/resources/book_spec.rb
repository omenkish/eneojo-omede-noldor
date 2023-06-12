# frozen_string_literal: true

RSpec.describe Noldor::Resources::Book do
  describe '#all' do
    context 'when credentials is not set' do
      before { Noldor.credentials.api_key = '' }

      it { expect { described_class.all }.to raise_error(Noldor::Exceptions::InvalidRequest, 'Please provide a valid api key') }
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

        after { Noldor.credentials.api_key = '' }

        it 'returns an array of book objects' do
          res = described_class.all

          expect(res.class).to eq(Noldor::Resources::Book)
          expect(res.data.data.first.name).to eq('The Lord of the Rings Series')
        end

        it 'correctly transforms nested keys to snake case' do
          res = described_class.all

          expect(res.data.data.first.academy_award_wins).to eq(17)
        end
      end
    end
  end

  describe '#find' do
    before do
      Noldor.credentials.api_key = 'hello there'

      fixture_base_path = File.join('spec', 'fixtures', 'noldor', 'resources')
      fixture_file_path = File.join(fixture_base_path, 'success.json')
      response = File.read(fixture_file_path)

      WebMock
        .stub_request(:get, "https://test-the-one-api.dev/book/#{JSON.parse(response)['docs'][0]['_id']}")
        .to_return(body: response, status: 200)
    end

    after { Noldor.credentials.api_key = '' }

    it 'returns only 1 data' do
      res = described_class.find(id: '5cd95395de30eff6ebccde56')

      expect(res.status).to eq(200)
      expect(res.data.name).to eq('The Lord of the Rings Series')
    end
  end

  describe '#book_chapters' do
    before do
      Noldor.credentials.api_key = 'hello there'

      fixture_base_path = File.join('spec', 'fixtures', 'noldor', 'resources')
      fixture_file_path = File.join(fixture_base_path, 'success.json')
      response = File.read(fixture_file_path)

      WebMock
        .stub_request(:get, "https://test-the-one-api.dev/book/#{JSON.parse(response)['docs'][0]['_id']}/chapter")
        .to_return(body: response, status: 200)
    end

    after { Noldor.credentials.api_key = '' }

    it 'successfully retrieves data' do
      res = described_class.book_chapters(book_id: '5cd95395de30eff6ebccde56')

      expect(res.status).to eq(200)
      expect(res.data.data.first.name).to eq('The Lord of the Rings Series')
    end
  end
end
