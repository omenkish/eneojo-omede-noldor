# frozen_string_literal: true

RSpec.describe Noldor::Resources::Movie do
  describe '#all' do
    context 'when credentials is not set' do
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
            .stub_request(:get, 'https://test-the-one-api.dev/movie')
            .to_return(body: response, status: 200)
        end

        after { Noldor.credentials.api_key = '' }

        it 'returns an array of movie objects' do
          res = described_class.all

          expect(res.class).to eq(Noldor::Resources::Movie)
          expect(res.data.docs.first.name).to eq('The Lord of the Rings Series')
        end

        it 'correctly transforms nested keys to snake case' do
          res = described_class.all

          expect(res.data.docs.first.academy_award_wins).to eq(17)
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
        .stub_request(:get, "https://test-the-one-api.dev/movie/#{JSON.parse(response)['docs'][0]['_id']}")
        .to_return(body: response, status: 200)
    end

    after { Noldor.credentials.api_key = '' }

    it 'successfully retrieves data' do
      res = described_class.find(id: '5cd95395de30eff6ebccde56')

      expect(res.status).to eq(200)
    end
  end

  describe '#movie_quotes' do
    before do
      Noldor.credentials.api_key = 'hello there'

      fixture_base_path = File.join('spec', 'fixtures', 'noldor', 'resources')
      fixture_file_path = File.join(fixture_base_path, 'success.json')
      response = File.read(fixture_file_path)

      WebMock
        .stub_request(:get, "https://test-the-one-api.dev/movie/#{JSON.parse(response)['docs'][0]['_id']}/quote")
        .to_return(body: response, status: 200)
    end

    after { Noldor.credentials.api_key = '' }

    it 'successfully retrieves data' do
      res = described_class.movie_quotes(movie_id: '5cd95395de30eff6ebccde56')

      expect(res.status).to eq(200)
    end

    context 'with options provided' do
      before do
        Noldor.credentials.api_key = 'api_key'

        fixture_base_path = File.join('spec', 'fixtures', 'noldor', 'resources')
        fixture_file_path = File.join(fixture_base_path, 'success.json')
        response = File.read(fixture_file_path)

        WebMock
          .stub_request(:get, "https://test-the-one-api.dev/movie/#{JSON.parse(response)['docs'][0]['_id']}/quote?limit=10")
          .to_return(body: response, status: 200)
      end

      after { Noldor.credentials.api_key = '' }

      it 'successfully retrieves data' do
        res = described_class.movie_quotes(options: {limit: 10}, movie_id: '5cd95395de30eff6ebccde56')

        expect(res.status).to eq(200)
      end
    end
  end
end
