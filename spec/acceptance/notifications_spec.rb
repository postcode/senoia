require_relative "./acceptance_helper"

feature "Notifications", js: true do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:creator) { create(:user) }
  
  context "Creator" do

    let(:plan) { create(:plan_awaiting_review, creator: creator) }
    
    context "when their plan is reviewed" do

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
    
    context "when their plan is approved" do

      before do
        sign_in(admin)
        visit "/plans/#{plan.id}"
        click_link "APPROVE PLAN"
        sign_out
      end
      
      scenario "receives an email notification" do
        email = find_email(creator.email)
        expect(email).to_not be_nil
        expect(email).to have_body_text("approved")
      end

      scenario "receives an on-site notification" do
        sign_in(creator)
        visit "/plans"
        notification = find(".alert-box", text: plan.name)
        expect(notification).to have_content("approved")
      end
      
    end

    context "when someone comments on their plan" do

      let(:comment_body) { Faker::Lorem.paragraph }
      
      before do
        sign_in(admin)
        visit "/plans/#{plan.id}"
        post_comment(comment_body)
        sign_out
      end
      
      scenario "receives an email notification" do
        email = find_email(creator.email)
        expect(email).to_not be_nil
        expect(email).to have_body_text(comment_body)
      end

      scenario "receives an on-site notification" do
        sign_in(creator)
        visit "/plans"
        notification = find(".alert-box", text: plan.name)
        expect(notification).to have_content("commented")
      end

    end
    
  end

  context "Admin" do

    context "when a new plan is submitted" do

      let(:plan) { create(:plan, workflow_state: "draft", creator: creator) }
      
      before do
        sign_in(admin)
        sign_out
        sign_in(creator)
        @event_type = create(:event_type)
        visit "/plans/new"
        fill_in 'plan_name', with: "New plan"
        select @event_type.name, from: "plan_event_type_id"
        click_button "Continue"
        sign_out
      end

      scenario "receives an email notification" do
        pending
        email = find_email(admin.email)
        expect(email).to_not be_nil
        expect(email).to have_subject(/submitted/)
        expect(email).to have_body_text(plan.name)
      end

      scenario "receives an on-site notification" do
        pending
        sign_in(admin)
        visit "/plans"
        notification = find(".alert-box", text: plan.name)
        expect(notification).to have_content("New plan")
      end
              
    end
    
  end
  
end
