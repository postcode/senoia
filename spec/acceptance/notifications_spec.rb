require_relative "./acceptance_helper"

feature "Notifications" do

  let(:admin) { FactoryGirl.create(:admin) }
  
  context "Creator" do

    let(:creator) { create(:user) }
    let(:plan) { create(:plan_awaiting_review, creator: creator) }
    
    context "when their plan changes state" do

      before do
        sign_in(admin)
        visit "/plans/#{plan.id}"
        click_link "REQUEST REVISION"
        sign_out
      end
      
      scenario "receives an email notification" do
        email = find_email(creator.email)
        expect(email).to_not be_nil
        expect(email).to have_body_text("needs revision")
      end

      scenario "receives an on-site notification" do
        sign_in(creator)
        visit "/plans"
        notification = find(".alert-box", text: plan.name)
        expect(notification).to have_content("needs revision")
      end
      
    end
    
  end
  
end
