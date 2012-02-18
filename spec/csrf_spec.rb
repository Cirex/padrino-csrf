require_relative 'spec'

describe Padrino::CSRF do
  let :random_string do
    SecureRandom.hex(32)
  end

  it 'should validate CSRF tokens for POST requests' do
    app.post :test do
      # ...
    end

    post '/test', { _csrf_token: random_string }, 'rack.session' => { _csrf_token: random_string }
    last_response.should be_ok

    expect do
      post '/test', { _csrf_token: 'haaaax' }, 'rack.session' => { _csrf_token: random_string }
    end.to raise_error(Padrino::CSRF::InvalidToken)
  end

  it 'should validate CSRF tokens for PUT requests' do
    app.put :test do
      # ...
    end

    put '/test', { _csrf_token: random_string }, 'rack.session' => { _csrf_token: random_string }
    last_response.should be_ok

    expect do
      put '/test', { _csrf_token: 'haaaax' }, 'rack.session' => { _csrf_token: random_string }
    end.to raise_error(Padrino::CSRF::InvalidToken)
  end

  it 'should validate CSRF tokens for DELETE requests' do
    app.delete :test do
      # ...
    end

    delete '/test', { _csrf_token: random_string }, 'rack.session' => { _csrf_token: random_string }
    last_response.should be_ok

    expect do
      delete '/test', { _csrf_token: 'haaaax' }, 'rack.session' => { _csrf_token: random_string }
    end.to raise_error(Padrino::CSRF::InvalidToken)
  end

  it 'should not validate CSRF tokens for GET requests' do
    app.get :test do
      # ...
    end

    get '/test', {}, 'rack.session' => { _csrf_token: random_string }
    last_response.should be_ok
  end

  it 'can disable validation on a request by request basis when enabled globally' do
    app.enable :prevent_request_forgery
    app.post :test, protect: false do
      # ...
    end

    post '/test', {}, 'rack.session' => { _csrf_token: random_string }
    last_response.should be_ok
  end

  it 'can enable validation on a request by request basis when disabled globally' do
    app.disable :prevent_request_forgery
    app.post :test do
      # ...
    end

    post '/test', {}, 'rack.session' => { _csrf_token: random_string }
    last_response.should be_ok

    app.post :another_test, protect: true do
      # ...
    end

    post '/another_test', { _csrf_token: random_string }, 'rack.session' => { _csrf_token: random_string }
    last_response.should be_ok

    expect do
      post '/another_test', { _csrf_token: 'haaaax' }, 'rack.session' => { _csrf_token: random_string }
    end.to raise_error(Padrino::CSRF::InvalidToken)
  end
end