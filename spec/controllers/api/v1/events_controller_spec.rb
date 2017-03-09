require 'spec_helper'
require 'response_json'

RSpec.describe Api::V1::EventsController, type: :controller do

  let! (:event) {
    FactoryGirl.create(:user)
    FactoryGirl.create(:event)
  }

  describe 'GET #index' do
    it 'returns the events index' do
      FactoryGirl.create(:event)
      get :index, format: :json

      expect(response.status).to eq(200)
      expect(response.body).to eq(Event.all.to_json)
    end
  end

  describe 'GET #show' do
    it 'returns an event by id' do
      get :show, params: { id: event, format: :json }

      expect(response.body).to eq( Event.find(event.id).to_json )
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new event" do
        expect {
          post :create, params: { event: FactoryGirl.attributes_for(:event) }
        }.to change(Event, :count).by(1)

        expect(response.status).to eq(201)
        event = Event.last
        expect(response.body).to eq( event.to_json )
      end
    end

    context "with invalid attributes" do
      it "fails and renders the error message" do
        expect {
          post :create, params: { event: { name: ""} }
        }.not_to change(Event, :count)

        expect(response.status).to eq(422)
        expect(response_json).to eq({
          'message' => 'Validation Failed',
          'errors' =>[
            'Event needs at least one field'
          ]
        })

      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the event attributes' do
        put :update, params: { id: event, event: { name: "my new name"} }
        event.reload

        expect(event.name).to eq("my new name")
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'fails and renders error message' do
        put :update, params: { id: event, event: { name: "", description: "", location: "", start_date: nil , end_date: nil } }
        event.reload

        expect(event.name).not_to be nil
        expect(response.status).to eq(422)
        expect(response_json).to eq({
          'message' => 'Validation Failed',
          'errors' =>[
            'Event needs at least one field'
          ]
        })

      end
    end
  end

  describe 'DELETE #destroy' do
    it 'updates event removed as true' do
      delete  :destroy, params: { id: event }
      event.reload

      expect(event.removed).to be_truthy
      expect(response.status).to eq(204)
    end
  end

end
