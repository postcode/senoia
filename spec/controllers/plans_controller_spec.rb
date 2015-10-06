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

    context 'when logged in as an admin' do
      login_admin
      it 'renders the page' do
        get :index
        @plan = Plan.new(name:"Fun Run")
        expect(response).to be_success
      end
    end
  end

  describe 'GET new' do
    context 'the default view' do
      login_admin
      it 'renders the plan form' do
        get :new
        expect(response).to be_success
      end
    end
  end

  describe 'GET show' do
    let(:plan) { FactoryGirl.create(:approved_plan) }
    context 'when there is a plan' do
      it 'renders the show page' do
        get :show, id: plan.id
        expect(response).to be_success
      end
    end
  end

  describe "#create" do
    it "creates a plan" do
      @plane = Plan.create(name: Faker::App.name)
      expect(@plane).to be_an_instance_of Plan
    end
  end

end
