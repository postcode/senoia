require_relative "acceptance_helper"

feature "Comments" do

  let(:admin) { create(:admin) }
  let(:plan) { create(:plan_awaiting_review) }

  context "Admin", js: true do
    
    background do
      @comment = create(:comment)
      @plan_with_outstanding_comment = create(:plan, comments: [ @comment ])
      
      sign_in(admin)
    end

    context "on the comment dashboard" do

      background do
        visit "/comments"
      end
      
      scenario "views comments" do
        pending
        expect(page).to have_content(@plan_with_outstanding_comment.name)
        expect(page).to have_content(@comment.body)
      end

      scenario "resolves a comment" do
        pending
      end
      
      scenario "replies to a comment" do
        pending
      end

    end

    context "on the plan page" do

      background do
        plan.comments << (@comment_on_event_type = create(:comment_on_event_type))
        @new_comment_body = Faker::Lorem.paragraph
        visit "/plans/#{plan.id}"
      end
      
      scenario "posts a comment" do
        first("a.comment").click

        within ".new-comment-area" do
          find("textarea").set @new_comment_body
          click_on "SUBMIT"
        end
        expect(page).to have_content @new_comment_body
      end

      scenario "replies to a comment" do
        find(".comment-area textarea").set @new_comment_body
        click_on "REPLY"
        expect(page).to have_content @new_comment_body
      end

      scenario "resolves a comment" do
        click_on "RESOLVE"
        expect(page).to_not have_content @comment_on_event_type.body
      end

    end
    
  end
end
