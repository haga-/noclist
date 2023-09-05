require 'rspec'
require 'webmock/rspec'
require_relative '../client'

describe Client do
  let(:client) { Client.new }

  describe '#get_auth_token' do
    let(:token) { '67723F81-4206-BE4C-308C-2F749101B124' }
    context "when API doesn't raise any errors" do
      it 'returns the authentication token from the server response' do
        # API returns useless data in the response body, we only care about the header
        stub_request(:get, 'localhost:8888/auth').to_return(body: 'B29607BE4B3A4325773076AB7945BD51', headers: { 'Badsec-Authentication-Token' => token })

        auth_token = client.get_auth_token

        expect(auth_token).to eq(token)
      end
    end

    context "when API raises one error but succeeds on the next retry" do
      it 'returns the authentication token from the server response' do
        stub_request(:get, 'localhost:8888/auth')
          .to_return(
            { status: 500, body: 'Internal Server Error' },
            { body: 'B29607BE4B3A4325773076AB7945BD51', headers: { 'Badsec-Authentication-Token' => token } }
          )

        auth_token = client.get_auth_token

        expect(auth_token).to eq(token)
      end
    end

    context "when API raises two errors but succeeds on the next retry" do
      it 'returns the authentication token from the server response' do
        stub_request(:get, 'localhost:8888/auth')
          .to_return(
            { status: 500, body: 'Internal Server Error' },
            { status: 404, body: 'Not Found' },
            { body: 'B29607BE4B3A4325773076AB7945BD51', headers: { 'Badsec-Authentication-Token' => token } }
          )

        auth_token = client.get_auth_token

        expect(auth_token).to eq(token)
      end
    end
    context "when API raises more than two errors" do
      it 'fails' do
        stub_request(:get, 'localhost:8888/auth')
          .to_return(
            { status: 500, body: 'Internal Server Error' },
            { status: 404, body: 'Not Found' },
            { status: 500, body: 'Internal Server Error' },
            { body: 'B29607BE4B3A4325773076AB7945BD51', headers: { 'Badsec-Authentication-Token' => token } }
          )

        expect{ client.get_auth_token }.to raise_error(Client::Error)
      end
    end
  end

  describe '#get_users' do
    let(:users_list) { "18207056982152612516\n7692335473348482352\n6944230214351225668\n3628386513825310392\n8189326092454270383\n12257150257418962584\n15245671842903013860\n6123808318520183820\n2369758755179393951\n11199617667907522182\n17679958362462205107\n8161384308545570741\n17905933069300437710\n2128366919142314320\n8050198496000226474\n12285596562078846341\n17498264813380685804\n15878820492083617521\n13852292911651453672\n17337865973615628454\n9229455752287942842\n7276261224779907663\n1739512995212175590\n8755001447812608547\n12490857963551106851\n11361123386737171544\n9568729738456525675\n7299386991593269749\n10786704641810476266\n5473944502633417925\n14253488556059378189\n14319538188300915189\n4660829384912539755\n661873756344312272\n9084860398647086882\n6471708071048854006\n4322572609509483582\n12344026228624416837\n12374588821574841291\n8920530543498641549\n12124692496822977637\n12524470487343793064\n15760024072391938219\n16504973638458783072\n13653696933022620424\n12631380398739473811\n5704443017213828170\n5553955800590348530\n16243288493962424038\n8556936092924245870\n14091093140311075469\n3814133641198355037\n7637672811351545355\n4075283707084492266\n15803548898562307514\n17108377201160133721\n5413190493951543960\n16350041139552811629\n3785541205673408781\n6052895740344310564\n9986143740894816983\n3374252707548930643\n8297434677357993039\n4322836435026298260" }

    it 'sends a request with the correct headers and returns the response body' do
      token = '67723F81-4206-BE4C-308C-2F749101B124'
      checksum = Digest::SHA256.hexdigest(token + '/users')
      stub_request(:get, 'localhost:8888/users')
        .with(headers: {'X-Request-Checksum' => checksum })
        .to_return(body: users_list)

      response_body = client.get_users(token)

      expect(response_body).to eq(users_list)
    end
  end
end
