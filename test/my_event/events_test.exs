defmodule MyEvent.EventsTest do
  use MyEvent.DataCase

  alias MyEvent.Events

  describe "events" do
    alias MyEvent.Events.Event

    import MyEvent.EventsFixtures

    @invalid_attrs %{description: nil, title: nil, location: nil, start_time: nil, end_time: nil, is_public: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{description: "some description", title: "some title", location: "some location", start_time: ~U[2025-07-28 07:20:00Z], end_time: ~U[2025-07-28 07:20:00Z], is_public: true}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.description == "some description"
      assert event.title == "some title"
      assert event.location == "some location"
      assert event.start_time == ~U[2025-07-28 07:20:00Z]
      assert event.end_time == ~U[2025-07-28 07:20:00Z]
      assert event.is_public == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", location: "some updated location", start_time: ~U[2025-07-29 07:20:00Z], end_time: ~U[2025-07-29 07:20:00Z], is_public: false}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.description == "some updated description"
      assert event.title == "some updated title"
      assert event.location == "some updated location"
      assert event.start_time == ~U[2025-07-29 07:20:00Z]
      assert event.end_time == ~U[2025-07-29 07:20:00Z]
      assert event.is_public == false
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
