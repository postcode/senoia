require 'rails_helper'

RSpec.describe PlanEventsController do
  describe "#create" do

    let(:plan) { create(:plan) }
    
    context "when logged in as admin" do

      login_admin

      it "approves a plan" do
        plan.update(workflow_state: "being_reviewed")
        expect { 
          post :create, { plan_id: plan.id, event: "accept" }
        }.to change{ Plan.with_accepted_state.count }.by(1)
      end

      it "reviews a plan" do
        plan.update(workflow_state: "awaiting_review")
        expect { 
          post :create, { plan_id: plan.id, event: "review" }
        }.to change{ Plan.with_being_reviewed_state.count }.by(1)
      end

      it "rejects a plan" do
        plan.update(workflow_state: "being_reviewed")
        expect { 
          post :create, { plan_id: plan.id, event: "reject" }
        }.to change{ Plan.with_rejected_state.count }.by(1)
      end

    end

    context "when logged in as a plan collaborator" do

      let(:collaborator) { create(:user) }
      
      before do
        plan.users_who_can_edit << collaborator
        sign_in collaborator
      end

      it "submits a plan" do
        plan.update(workflow_state: "draft")
        expect { 
          post :create, { plan_id: plan.id, event: "submit" }
        }.to change{ Plan.with_awaiting_review_state.count }.by(1)
      end

      it "doesn't approve a plan" do
        plan.update(workflow_state: "being_reviewed")
        expect { 
          post :create, { plan_id: plan.id, event: "accept" }
        }.to change{ Plan.with_accepted_state.count }.by(0)
      end
      
      it "doesn't review a plan" do
        plan.update(workflow_state: "awaiting_review")
        expect { 
          post :create, { plan_id: plan.id, event: "review" }
        }.to change{ Plan.with_being_reviewed_state.count }.by(0)
      end

      it "doesn't reject a plan" do
        plan.update(workflow_state: "being_reviewed")
        expect { 
          post :create, { plan_id: plan.id, event: "reject" }
        }.to change{ Plan.with_rejected_state.count }.by(0)
      end

    end
  end
end
