require_relative "acceptance_helper"

feature "Comments" do

  let(:admin) { create(:admin) }
  let(:guest) { create(:user) }
  let(:user) { create(:user, roles: "user") }
  let(:plan) { create(:plan_under_review, creator: user) }

  context "Admin", js: true do

    background do
      @comment = create(:comment)
      @plan_with_outstanding_comment = create(:plan, comments: [ @comment ])
      @reply_body = Faker::Lorem.paragraph

      sign_in(admin)
    end

    context "on the comment dashboard" do

      background do
        visit "/comments"
      end

      scenario "views comments" do
        expect(page).to have_content(@plan_with_outstanding_comment.name)
        click_on "1 comment"
        expect(page).to have_content(@comment.body)
      end

      scenario "resolves a comment" do
        click_on "1 comment"
        click_on "RESOLVE"
        expect(page).to_not have_content @comment.body
      end

      scenario "replies to a comment" do
        click_on "1 comment"
        find("textarea").set @reply_body
        click_on "REPLY"
        expect(page).to have_content @reply_body
      end

    end

    context "on the plan page" do

      background do
        plan.comments << (@comment_on_event_type = create(:comment_on_event_type))
        @new_comment_body = Faker::Lorem.paragraph
        visit "/plans/#{plan.id}"
      end

      scenario "views a comment" do
        expect(page).to have_content @comment_on_event_type.body
      end

      scenario "posts a comment" do
        post_comment(@new_comment_body)
        expect(page).to have_content @new_comment_body
      end

      scenario "posts a comment twice" do
        2.times do
          new_comment_body = Faker::Lorem.paragraph
          first("a.comment").click

          within ".new-comment-area" do
            find("textarea").set new_comment_body
            click_on "SUBMIT"
          end

          expect(page).to have_content new_comment_body
        end
      end

      scenario "replies to a comment" do
        find(".comment-area textarea").set @new_comment_body
        click_on "REPLY"
        expect(page).to have_content @new_comment_body
      end

      scenario "replies to a comment twice" do
        2.times do
          new_comment_body = Faker::Lorem.paragraph
          find(".comment-area textarea").set new_comment_body
          click_on "REPLY"
          expect(page).to have_content new_comment_body
        end
      end

      scenario "resolves a comment" do
        click_on "RESOLVE"
        expect(page).to_not have_content @comment_on_event_type.body
      end
    end
  end

  context "Guest" do

    background do
      sign_in(guest)
    end

    scenario "cannot view the comment dashboard" do
      visit "/comments"
      expect(page).to have_content "not authorized"
    end
  end

  context "User", js: true do

    background do
      @comment = create(:comment)
      @plan_with_outstanding_comment = create(:plan, comments: [ @comment ])
      @reply_body = Faker::Lorem.paragraph

      sign_in(user)
    end

    context "on the comment dashboard" do

      background do
        visit "/comments"
      end

      scenario "views comments" do
        expect(page).to have_content(@plan_with_outstanding_comment.name)
        click_on "1 comment"
        expect(page).to have_content(@comment.body)
      end

      scenario "resolves a comment" do
        expect(page).to_not have_content "RESOLVE"
      end
    end

    context "on the plan page" do

      background do
        plan.comments << (@comment_on_event_type = create(:comment_on_event_type))
        @new_comment_body = Faker::Lorem.paragraph
        visit "/plans/#{plan.id}"
      end

      scenario "views a comment" do
        expect(page).to have_content @comment_on_event_type.body
      end

      scenario "posts a comment" do
        post_comment(@new_comment_body)
        expect(page).to have_content @new_comment_body
      end

      scenario "replies to a comment" do
        find(".comment-area textarea").set @new_comment_body
        click_on "REPLY"
        expect(page).to have_content @new_comment_body
      end

      scenario "replies to a comment twice" do
        2.times do
          new_comment_body = Faker::Lorem.paragraph
          find(".comment-area textarea").set new_comment_body
          click_on "REPLY"
          expect(page).to have_content new_comment_body
        end
      end

      scenario "resolves a comment" do
        expect(page).to_not have_content "RESOLVE"
      end
    end
  end
end
