require_relative "./acceptance_helper"

feature "Notifications", js: true do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:creator) { create(:user) }

  context "Creator" do
    let(:plan) { create(:plan_under_review, creator: creator) }

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
  end

  context "Admin" do
    context "when a new plan is submitted" do
      let(:plan) { create(:plan, workflow_state: "draft", creator: creator) }

      before do
        sign_in(admin)
        sign_out
        sign_in(creator)
        visit "/plans/#{plan.id}"
        click_link "SUBMIT PLAN"
        sign_out
      end

      scenario "receives an email notification" do
        email = find_email(admin.email)
        expect(email).to_not be_nil
        expect(email).to have_subject(/submitted/)
        expect(email).to have_body_text(plan.name)
      end

      scenario "receives an on-site notification" do
        sign_in(admin)
        visit "/plans"
        notification = find(".alert-box", text: plan.name)
        expect(notification).to have_content("New plan")
      end
    end
  end

  context "Notification Group Member" do
    context "when a plan is approved" do
      let(:plan) { create(:plan_under_review) }
      let(:group_member) { create(:user) }
      let(:notification_group) { create(:notification_group, notification_type: "plan.approved") }

      before do
        notification_group.members << group_member
        sign_in(admin)
        visit "/plans/#{plan.id}"
        click_link "APPROVE PLAN"
        sign_out
      end

      scenario "receives an email notification" do
        email = find_email(group_member.email)
        expect(email).to_not be_nil
        expect(email).to have_body_text("approved")
      end

      scenario "receives an on-site notification" do
        sign_in(group_member)
        visit "/plans"
        notification = find(".alert-box", text: plan.name)
        expect(notification).to have_content("approved")
      end
    end
  end
end
