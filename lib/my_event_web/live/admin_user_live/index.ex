defmodule MyEventWeb.AdminUserLive.Index do
  use MyEventWeb, :live_view

  alias MyEvent.Accounts


  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users()
    {:ok, assign(socket, users: users)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)
    {:noreply, assign(socket, users: Accounts.list_users())}
  end
end
