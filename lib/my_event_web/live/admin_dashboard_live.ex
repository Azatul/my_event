defmodule MyEventWeb.AdminDashboardLive do
  use MyEventWeb, :live_view

  alias MyEvent.Accounts

  @impl true
def mount(_params, session, socket) do
  if connected?(socket), do: :timer.send_interval(60_000, :tick)

  pagination = Accounts.paginate_users(1, 5)

  socket =
    socket
    |> assign_new(:current_user, fn -> session["current_user"] end)
    |> assign_new(:current_admin, fn -> session["current_admin"] end)
    |> assign(:users, pagination.users)
    |> assign(:pagination, pagination)
    |> assign(:current_page, :admin_dashboard_overview)
    |> assign(:filter_letter, nil)
    |> assign(:search_query, nil)

  {:ok, socket}
end


  @impl true
  def handle_info({:switch_page, page}, socket) do
    {:noreply, assign(socket, current_page: page)}
  end

  @impl true
  def handle_event("paginate", %{"page" => page}, socket) do
    letter = socket.assigns.filter_letter || ""
    push_to = ~p"/admin/dashboard?letter=#{letter}&page=#{page}"
    {:noreply, push_patch(socket, to: push_to)}
  end


  @impl true
  def handle_event("filter_letter", %{"letter" => letter}, socket) do
    push_to = ~p"/admin/dashboard?letter=#{letter}&page=1"
    {:noreply, push_patch(socket, to: push_to)}
  end

  def handle_event("search", %{"q" => query}, socket) do
    push_to = ~p"/admin/dashboard?q=#{query}&page=1"
    {:noreply, push_patch(socket, to: push_to)}
  end


@impl true
def handle_params(params, _uri, socket) do
  page = Map.get(params, "page", "1") |> String.to_integer()
  query = Map.get(params, "q")
  letter = Map.get(params, "letter")
  per_page = 5

  pagination =
    cond do
      query && query != "" ->
        Accounts.search_users_by_name(query, page, per_page)

      letter && letter != "" ->
        Accounts.filter_users_by_letter(letter, page, per_page)

      true ->
        Accounts.paginate_users(page, per_page)
    end

  {:noreply,
   assign(socket,
     users: pagination.users,
     pagination: pagination,
     filter_letter: letter,
     search_query: query
   )}
end


  @impl true
  def render(assigns) do
    ~H"""
  <div class="flex h-screen">
    <!-- Sidebar -->
    <.live_component module={MyEventWeb.AdminSidebarLiveComponent} id="admin_sidebar" />

    <!-- Main Content Area -->
    <main class="flex-1 p-6 overflow-y-auto">
      <%= case @current_page do %>

        <% :admin_dashboard_overview -> %>
          <h1 class="text-2xl font-bold mb-4">Registered User</h1>

        <div class="overflow-x-auto">
          <div class="mb-4">
         <form phx-change="filter_letter">
         <label for="letter-filter" class="block mb-1 font-medium">Filter by Email A–Z</label>
         <select name="letter" id="letter-filter" class="border rounded px-3 py-1">
          <option value="">All</option>
          <%= for <<letter <- "ABCDEFGHIJKLMNOPQRSTUVWXYZ">> do %>
           <option value={<<letter>>} selected={@filter_letter == <<letter>>}>
             <%= <<letter>> %>
           </option>
         <% end %>
       </select>
     </form>

     <form phx-change="search" class="mb-4 flex justify-end">
  <input
    type="text"
    name="q"
    value={@search_query || ""}
    placeholder="Search full name..."
    class="border px-2 py-1 rounded w-1/3"
  />
</form>

    </div>

            <table class="table-auto w-full border">
              <thead>
                <tr class="bg-gray-100">
                  <th class="px-4 py-2 border">No</th>
                  <th class="px-4 py-2 border">Full Name</th>
                  <th class="px-4 py-2 border">Email</th>
                  <th class="px-4 py-2 border">Actions</th>
                </tr>
              </thead>
              <tbody>
                <%= for {user, index} <- Enum.with_index(@users) do %>
                  <tr>
                    <td class="border px-4 py-2">
                      <%= ((@pagination.page - 1) * @pagination.per_page) + index + 1 %>
                    </td>
                    <td class="border px-4 py-2"><%= user.full_name %></td>
                    <td class="border px-4 py-2"><%= user.email %></td>
                    <td class="border px-4 py-2">
                      <button
                        phx-click="delete"
                        phx-value-id={user.id}
                        class="text-red-500"
                        data-confirm="Are you sure?"
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>

            <!-- Pagination Controls -->
            <div class="flex justify-center space-x-2 mt-4">
              <%= for p <- 1..@pagination.total_pages do %>
                <button
                  phx-click="paginate"
                  phx-value-page={p}
                  class={"px-3 py-1 border rounded #{if p == @pagination.page, do: "bg-blue-500 text-white", else: "bg-gray-100"}"}
                >
                  <%= p %>
                </button>
              <% end %>
            </div>
          </div>

        <% :admin_dashboard_events -> %>
          <h1 class="text-2xl font-bold mb-4">Event Management</h1>
          <p>Manage all public/private events here.</p>

        <% :admin_settings -> %>
          <h1 class="text-2xl font-bold mb-4">Admin Settings</h1>
          <p>Admin settings go here.</p>

      <% end %>
    </main>
  </div>
  """
end
end
