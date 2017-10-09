require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get events_url, as: :json
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post events_url, params: { event: { category: @event.category, current_capacity: @event.current_capacity, description: @event.description, host_id: @event.host_id, interest_rating: @event.interest_rating, location: @event.location, name: @event.name, review_host_prep: @event.review_host_prep, review_matched_desc: @event.review_matched_desc, review_would_ret: @event.review_would_ret, time: @event.time, total_capacity: @event.total_capacity } }, as: :json
    end

    assert_response 201
  end

  test "should show event" do
    get event_url(@event), as: :json
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { category: @event.category, current_capacity: @event.current_capacity, description: @event.description, host_id: @event.host_id, interest_rating: @event.interest_rating, location: @event.location, name: @event.name, review_host_prep: @event.review_host_prep, review_matched_desc: @event.review_matched_desc, review_would_ret: @event.review_would_ret, time: @event.time, total_capacity: @event.total_capacity } }, as: :json
    assert_response 200
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event), as: :json
    end

    assert_response 204
  end
end
