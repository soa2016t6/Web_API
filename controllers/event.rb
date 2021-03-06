# frozen_string_literal: true
# Controller for the events
class EventsLocatorAPI < Sinatra::Base
  # route to find events based on location defined by
  # latitude[-90<>90] & longitude[-180<>180]

  get "/#{API_VER}/events/search/:city/:term" do
    results = SearchByText.call(params)
    content_type 'application/json'
    if results.success?
      EventsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/events/by_id/:id" do
    results = GetEvent.call(params)
    content_type 'application/json'
    if results.success?
      EventRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/city/:id/events/?" do
    results = SearchByCity.call(params)
    content_type 'application/json'
    if results.success?
      EventsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/events/:lat&:lon" do
    latitude = params[:lat]
    longitude = params[:lon]
    begin
      response = Meetup::MeetupApi.get_events(latitude, longitude)
      content_type 'application/json'
      return EventsRepresenter.new(response)
    rescue
      return Error.new(:not_found, "Events at location (lan:#{latitude},lon:#{longitude}) not found!")
    end
  end
end
