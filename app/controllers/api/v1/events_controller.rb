class Api::V1::EventsController < ApplicationController

  before_action :set_event, except: [:index, :create]

  def index
    render json: Event.all
  end

  def show
    render json: @event
  end

  def create
    user = User.find(1)
    @event = user.events.new(event_params)

    if @event.save
      render json: @event, status: :created
    else
      event_failed
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      event_failed
    end
  end

  def destroy
    @event.tag_as_removed
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_failed
    render json: {
      message: 'Validation Failed',
      errors: @event.errors.full_messages
    }, status: 422
  end

  def event_params
    params.require(:event).permit(:name, :description, :location, :start_date, :end_date, :user_id)
  end

end
