require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user)     { create :confirmed_user }
  let(:category) { create :category }
  let(:question) { create :question, author: user }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, id: question.id
      expect(response).to be_success
    end

    it "updates views count" do
      views_before = question.views

      get :show, id: question.id
      expect(question.reload.views).to eq(views_before + 1)
    end
  end

  describe "GET #new" do
    context "when not signed in" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      it "returns http success" do
        sign_in user

        get :new
        expect(response).to be_success
      end
    end
  end

  describe "POST #create" do
    context "when not signed in" do
      it "redirects to sign in page" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      it "creates question and redirects to question page" do
        sign_in user

        expect {
          post :create, question: attributes_for(:question, category_id: category.id)
        }.to change(Question, :count).by(1)
        expect(response).to redirect_to(Question.last)
      end
    end
  end
end
