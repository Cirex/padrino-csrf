require_relative 'spec'

describe Padrino::CSRF::Helpers do
  include Padrino::Helpers::AssetTagHelpers
  include Padrino::Helpers::OutputHelpers
  include Padrino::Helpers::FormHelpers
  include Padrino::Helpers::TagHelpers
  include Padrino::CSRF::FormHelpers
  include Padrino::CSRF::Helpers

  let :params do
    {}
  end

  let :session do
    { _csrf_token: SecureRandom.hex(32) }
  end

  let :request do
    Sinatra::Request.new('HTTP_X_CSRF_TOKEN' => nil)
  end

  context '#csrf_valid?' do
    it 'should return false when the CSRF param is invalid' do
      params[csrf_param] = csrf_token[0..-2]
      csrf_valid?.should be_false
    end

    it 'should return true when the CSRF param is valid' do
      params[csrf_param] = csrf_token
      csrf_valid?.should be_true
    end

    it 'should return false when the CSRF header is invalid' do
      request.stub(:env).and_return('HTTP_X_CSRF_TOKEN' => csrf_token[0..-2])
      csrf_valid?.should be_false
    end

    it 'should return true when the CSRF header is valid' do
      request.stub(:env).and_return('HTTP_X_CSRF_TOKEN' => csrf_token)
      csrf_valid?.should be_true
    end
  end

  context '#csrf_meta_tags' do
    it 'should return meta tags with the current token and parameter' do
      meta_tags = csrf_meta_tags
      meta_tags.should have_tag(:meta, count: 1, with: { name: 'csrf-param', content: csrf_param })
      meta_tags.should have_tag(:meta, count: 1, with: { name: 'csrf-token', content: csrf_token })
    end
  end

  context '#csrf_token' do
    it 'should return the current sessions CSRF token' do
      csrf_token.should == session[csrf_param]
    end

    it 'should set the sessions CSRF token when one is not present' do
      session.clear
      session[csrf_param].should be_nil
      csrf_token.should_not be_nil
      session[csrf_param].should_not be_nil
    end
  end

  context '#form_tag' do
    it 'should prepend the CSRF authenticity token to the form' do
      form = form_tag('/register') { text_field_tag :user_name, value: 'test' }
      form.should have_tag(:form, count: 1, with: { method: 'post',  action: '/register' }) do
        with_tag(:input, count: 1, with: { type: 'hidden', name: csrf_param, value: csrf_token })
        with_tag(:input, count: 1, with: { type: 'text', name: 'user_name', value: 'test' })
      end
    end
  end

  context '#token_field_tag' do
    it 'should return a hidden input with the current CSRF token' do
      input = token_field_tag
      input.should have_tag(:input, count: 1, with: { type: 'hidden', name: csrf_param, value: csrf_token })
    end
  end
end