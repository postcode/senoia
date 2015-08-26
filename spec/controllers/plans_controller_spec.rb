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
    let(:plan) { FactoryGirl.create(:plan) }
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

  describe "#add_comment" do

    let(:plan) { FactoryGirl.create(:plan) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
    
    context "when logged in as admin" do

      login_admin

      it "creates a comment" do
        post :add_comment, { "comment_text" => Faker::Lorem.paragraph, "element_id" => "contact_comment_text", "id" => plan.id, "format" => "js" }
        expect(response).to be_success
        expect(assigns(:comment)).to be_an_instance_of Comment
      end

      let(:notification_recipient) { FactoryGirl.create(:user) }

      it "sends notifications" do

        plan.users << notification_recipient
        
        expect(NotificationMailer).to receive(:new_comment_notification)
          .with({ recipient: notification_recipient, comment: kind_of(Comment) })
          .and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        
        post :add_comment, { "comment_text" => Faker::Lorem.paragraph, "element_id" => "contact_comment_text", "id" => plan.id, "format" => "js" }
      end
      
    end
  end
end
