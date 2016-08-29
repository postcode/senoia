require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  describe "#update" do

    let(:user) { create(:user) }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    it "doesn't allow users to change their own roles" do
      expect {
        put :update, { "user" => { "roles" => "admin", "current_password" => user.password } }
      }.to change { User.all.select(&:is_admin?).count }.by(0)
    end
  end
end
