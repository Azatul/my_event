defmodule MyEvent.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyEvent.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_time: ~U[2025-07-28 07:20:00Z],
        is_public: true,
        location: "some location",
        start_time: ~U[2025-07-28 07:20:00Z],
        title: "some title"
      })
      |> MyEvent.Events.create_event()

    event
  end
end
