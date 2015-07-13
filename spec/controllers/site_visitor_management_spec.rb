require 'spec_helper'

describe GreenFlag::SiteVisitorManagement do

  controller(ActionController::Base) do
    include GreenFlag::SiteVisitorManagement

    def index
      render :text => 'foo'
    end

    def current_user
      nil
    end
  end

  let(:cookie_name) { GreenFlag::SiteVisitorManagement::COOKIE_NAME }

  it 'does not prevent the controller from rendering' do
    get :index
    expect(response).to be_success
  end

  context '#set_site_visitor' do
    context 'when there is no vistor cookie' do
      it 'does not create a new visitor' do
        expect{ get :index }.to_not change { GreenFlag::SiteVisitor.count }
      end

      it 'sets the visitor cookie' do
        get :index
        expect(response.cookies[cookie_name]).to be_present
      end
    end

    context 'when there is a visitor cookie' do
      before(:each) do
        request.cookies[cookie_name] = '2d931510-d99f-494a-8c67-87feb05e1594'
      end

      it 'does not create a new visitor' do
        expect{ get :index }.to_not change { GreenFlag::SiteVisitor.count }
      end
      it 'calls record_login when there is a current_user' do
        user = double
        controller.stub(:current_user) { user }
        expect(controller).to receive(:record_login).with(user)
        get :index
      end
    end
  end


end