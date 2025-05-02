require 'rails_helper'

RSpec.describe Instructor::QuestionsController, type: :controller do
  let!(:instructor) { FactoryBot.create(:user, :instructor) }
  let!(:topic) { FactoryBot.create(:topic) }
  let!(:type) { FactoryBot.create(:type) }

  let!(:question_1) { FactoryBot.create(:question, question_kind: "dataset", topic: topic, type: type) }
  let!(:question_2) { FactoryBot.create(:question, question_kind: "equation", topic: topic, type: type) }

  before do
    allow(controller).to receive(:current_user).and_return(instructor)
  end

  describe "GET #index" do
    it "returns all questions if no filter is applied" do
      get :index
      expect(assigns(:questions)).to match_array([ question_1, question_2 ])
      expect(assigns(:question_kinds)).to include("dataset", "equation")
    end

    it "filters questions by question_kind" do
      get :index, params: { question_kind: "dataset" }
      expect(assigns(:questions)).to eq([ question_1 ])
    end
  end

  describe "GET #edit" do
    it "assigns the requested question" do
      get :edit, params: { id: question_1.id }
      expect(assigns(:question)).to eq(question_1)
      expect(assigns(:topics)).to include(topic)
      expect(assigns(:types)).to include(type)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the question and redirects" do
        patch :update, params: {
          id: question_1.id,
          question: { template_text: "Updated template" }
        }
        expect(response).to redirect_to(instructor_questions_path)
        expect(flash[:notice]).to eq("Question updated successfully!")
        expect(question_1.reload.template_text).to eq("Updated template")
      end
    end

    context "with invalid parameters" do
      it "renders edit with an alert" do
        allow_any_instance_of(Question).to receive(:update).and_return(false)

        patch :update, params: {
          id: question_1.id,
          question: { template_text: "" }
        }
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to eq("There was an error updating the question.")
      end
    end

    context "updating an equation question" do
      let(:eq_question) { FactoryBot.create(:question, question_kind: "equation", topic: topic, type: type) }

      let(:valid_equation_params) do
        {
          template_text: "New equation text",
          equation: "x + y",
          round_decimals: "2",
          variables: [ "x", "y" ],
          variable_ranges: [ { "min" => "1", "max" => "3" }, { "min" => "2", "max" => "4" } ],
          variable_decimals: [ "0", "0" ]
        }
      end

      it "evaluates the new equation and updates the question" do
        patch :update, params: {
          id: eq_question.id, question: valid_equation_params
        }
        expect(response).to redirect_to(instructor_questions_path)
        q = eq_question.reload
        expect(q.template_text).to eq("New equation text")
      end

      it "redirects if equation is invalid" do
        invalid_equation_params = valid_equation_params.merge(equation: "invalid equation")
        patch :update, params: {
          id: eq_question.id, question: invalid_equation_params
        }
        expect(response).to redirect_to(custom_template_equation_path)
        expect(flash[:alert]).to match(/Invalid equation:/)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the question and redirects" do
      expect {
        delete :destroy, params: { id: question_1.id }
      }.to change(Question, :count).by(-1)

      expect(response).to redirect_to(instructor_questions_path)
      expect(flash[:notice]).to eq("Question deleted successfully.")
    end
  end
end
