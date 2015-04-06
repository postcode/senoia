require 'rails_helper'

RSpec.describe PlansController do
  describe 'GET index' do
    context 'when there are no plans' do
      it 'renders the page' do
        get :index
        expect(response).to be_success
      end
    end
    context 'when there at least is one plan' do
      it 'renders the page' do
        get :index
        @plan = Plan.new(name:"Fun Run")
        expect(response).to be_success
      end
    end
  end
end