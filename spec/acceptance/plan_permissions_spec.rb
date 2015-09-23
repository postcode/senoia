require_relative "./acceptance_helper"

feature "Plan Permissions" do

  shared_examples "can view" do

    background do
      visit "/plans/#{plan.id}"
    end
    
    scenario "can be viewed" do
      expect(page.body).to match %r{#{plan.name}}i
    end
    
  end

  shared_examples "cannot view" do

    background do
      visit "/plans/#{plan.id}"
    end

    scenario "cannot be viewed" do
      expect(page.body).to_not match %r{#{plan.name}}i
    end

  end

  shared_examples "cannot edit" do

    background do
      visit "/plans/#{plan.id}"
    end

    scenario "cannot be edited" do
      expect(page).to_not have_selector("input")
    end

  end
  
  shared_examples "can edit" do

    background do
      visit "/plans/#{plan.id}"
    end

    scenario "can be edited" do
      expect(page).to have_selector("input")
    end

  end

  ALL_STATES = Plan.workflow_spec.state_names
  
  context "as a guest" do

    context "a draft" do
      let(:plan) { create(:draft) }
      include_examples "cannot view"
    end

    context "an accepted plan" do
      let(:plan) { create(:accepted_plan) }
      include_examples "can view"
    end

  end

  context "as the creator" do

    let(:creator) { create(:user) }
    
    background do
      sign_in creator
    end

    context "a plan in state" do
      ALL_STATES.each do |state|
        context state do
          let(:plan) { create(:plan, workflow_state: state, creator: creator) }
          include_examples "can view"
        end
      end
    end    
  end

  context "as a viewer" do

    let(:viewer) { create(:user) }

    background do
      sign_in viewer
    end

    context "a plan in state" do
      ALL_STATES.each do |state|
        context state do
          let(:plan) { create(:plan, workflow_state: state, users_who_can_view: [ viewer ]) }
          include_examples "can view"
          include_examples "cannot edit"
        end
      end
    end
  end

  context "as an editor" do

    let(:editor) { create(:user) }

    background do
      sign_in editor
    end

    context "a plan in state" do
      ALL_STATES.each do |state|
        context state do
          let(:plan) { create(:plan, workflow_state: state, users_who_can_edit: [ editor ]) }
          include_examples "can view"

          if state == :accepted
            include_examples "cannot edit"
          else
            include_examples "can edit"
          end
        end
      end
    end
  end

  context "as an admin" do

    let(:admin) { create(:admin) }
    
    background do
      sign_in admin
    end

    context "a plan in state" do
      ALL_STATES.each do |state|
        context state do
          let(:plan) { create(:plan, workflow_state: state) }
          include_examples "can view"
        end
      end
    end
  end
  
end
