# spec/controllers/problems_controller_spec.rb
require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  let!(:topics) do
    [
      Topic.create!(topic_id: 1, topic_name: "Velocity"),
      Topic.create!(topic_id: 2, topic_name: "Acceleration"),
      Topic.create!(topic_id: 3, topic_name: "Equations of motion")
    ]
  end

  let!(:types) do
    [
      Type.create!(type_id: 1, type_name: "Definition"),
      Type.create!(type_id: 2, type_name: "Multiple Choice"),
      Type.create!(type_id: 3, type_name: "Free Response")
    ]
  end

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe 'POST #create' do
    context 'when submitting topics and types' do
        it 'saves the selected topics and question types in session' do
        post :create, params: { topic_ids: [1, 2], type_ids: [1, 3] }
        
        expect(session[:selected_topic_ids]).to eq(["1", "2"])
        expect(session[:selected_type_ids]).to eq(["1", "3"])
        end

        it 'handles empty selections' do
          post :create, params: { topic_ids: [], type_ids: [] }

          expect(session[:selected_topic_ids]).to eq([])
          expect(session[:selected_type_ids]).to eq([])
        end
    end
  end

  describe 'GET #problem_generation' do
    context 'when generating problems with selected topics and types' do
      before do
        session[:selected_topic_ids] = ["1", "2"]
        session[:selected_type_ids] = ["1", "3"]
      end

      it 'fetches the correct topics and question types based on session' do
        get :problem_generation
        
        expect(assigns(:selected_topics).map(&:topic_name)).to include("Velocity", "Acceleration")
        expect(assigns(:selected_types).map(&:type_name)).to include("Definition", "Free Response")
      end
    end
  end
end