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
  
  shared_examples "can edit" do

    background do
      visit "/plans/#{plan.id}"
    end

    scenario "can be edited" do
      expect(page).to have_selector("input")
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

  shared_examples "can comment" do
    background do
      visit "/plans/#{plan.id}"
    end

    scenario "can be commented on" do
      expect(page).to have_selector("a", text: "COMMENT")
    end
  end

  shared_examples "cannot comment" do
    background do
      visit "/plans/#{plan.id}"
    end

    scenario "cannot be commented on" do
      expect(page).to_not have_selector("a", text: "COMMENT")
    end
  end
  
  ALL_STATES = Plan.workflow_spec.state_names
  
  context "as a guest" do

    context "a draft" do
      let(:plan) { create(:draft) }
      include_examples "cannot view"
    end

    context "an approved plan" do
      let(:plan) { create(:approved_plan) }
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
          include_examples "can comment" if state.in? [ :under_review, :revision_requested ]
        end
      end
    end    
  end

  context "as a viewer" do

    let(:viewer) { create(:user) }

    background do
      sign_in viewer
    end

    context "a comment" do

      let(:plan) { create(:plan, users_who_can_view: [ viewer ]) }
      
      background do
        plan.comments << create(:comment, commentable: plan, element_id: "contact_comment_text")
        visit "/plans/#{plan.id}"
      end

      scenario "cannot be replied to" do
        expect(page).to_not have_selector("a", text: "REPLY")
      end
      
    end

    context "a plan in state" do
      ALL_STATES.each do |state|
        context state do
          let(:plan) { create(:plan, workflow_state: state, users_who_can_view: [ viewer ]) }
          include_examples "can view"
          include_examples "cannot edit"
          include_examples "cannot comment"
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

          if state == :approved
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
          include_examples "can edit"
          include_examples "can comment" unless state == :approved
        end
      end
    end
  end
  
end
