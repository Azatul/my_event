defmodule MyEventWeb.SidebarLiveComponent do
  use MyEventWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:dashboard_expanded, fn -> false end)
     |> assign_new(:collapsed, fn -> false end)}
  end


  def render(assigns) do
   ~H"""
<aside class={
  if @collapsed,
    do: "fixed top-0 left-0 w-16 h-[calc(100vh-4rem)] bg-white bg-opacity-90 backdrop-blur-md shadow-xl flex flex-col justify-between z-50 transition-all duration-300",
    else: "fixed top-0 left-0 w-64 h-[calc(100vh-4rem)] bg-white bg-opacity-90 backdrop-blur-md shadow-xl flex flex-col justify-between z-50 transition-all duration-300"
}>

  <!-- Collapse Toggle -->
  <div class="p-4 border-b border-gray-300 flex justify-between items-center">
    <button
      phx-click="toggle_collapse"
      phx-target={@myself}
      class="text-gray-700 text-lg focus:outline-none"
    >
      <%= if @collapsed, do: "☰", else: "✕" %>
    </button>
  </div>

  <!-- Menu -->
  <div class="p-4">
    <h2 :if={!@collapsed} class="text-xl font-bold text-gray-800 mb-4">User Menu</h2>

    <ul class="space-y-2 text-gray-700">
      <!-- Dashboard -->
      <li>
        <button
          phx-click="toggle_dashboard"
          phx-target={@myself}
          class="w-full text-left p-2 rounded-lg hover:bg-gray-200 transition font-medium"
        >
          <%= if @collapsed, do: "📊", else: "📊 Dashboard" %>
        </button>

        <%= if @dashboard_expanded && !@collapsed do %>
          <ul class="ml-4 mt-2 space-y-1 text-sm text-gray-600">
            <li>
              <button
                phx-click="dashboard_overview"
                phx-target={@myself}
                class="w-full text-left p-2 rounded-md hover:bg-gray-100 transition"
              >
                Overview
              </button>
            </li>
            <li>
              <button
                phx-click="dashboard_stats"
                phx-target={@myself}
                class="w-full text-left p-2 rounded-md hover:bg-gray-100 transition"
              >
                Stats
              </button>
            </li>
          </ul>
        <% end %>
      </li>

      <!-- Settings -->
      <li>
        <button
          phx-click="show_settings"
          phx-target={@myself}
          class="w-full text-left p-2 rounded-lg hover:bg-gray-200 transition font-medium"
        >
          <%= if @collapsed, do: "⚙️", else: "⚙️ Settings" %>
        </button>
      </li>

      <li>
    <.link
      href={~p"/users/log_out"}
      method="delete"
      class="w-full text-left block p-2 rounded-lg hover:bg-red-100 text-red-600 font-medium transition"
    >
      <%= if @collapsed, do: "🚪", else: "🚪 Log out" %>
    </.link>
  </li>

    </ul>
  </div>

  <!-- Footer -->
  <div class="p-4 border-t border-gray-300 text-sm text-gray-500">
    <%= if !@collapsed do %>
      Logged in as: <span class="font-semibold text-gray-700">User</span>
    <% else %>
      🙍‍♂️
    <% end %>
  </div>
</aside>
"""

  end

  def handle_event("toggle_dashboard", _params, socket) do
    {:noreply, update(socket, :dashboard_expanded, fn expanded -> !expanded end)}
  end

  def handle_event("dashboard_overview", _params, socket) do
    send(self(), {:switch_page, :dashboard_overview})
    {:noreply, socket}
  end

  def handle_event("dashboard_stats", _params, socket) do
    send(self(), {:switch_page, :dashboard_stats})
    {:noreply, socket}
  end

  def handle_event("toggle_collapse", _params, socket) do
    {:noreply, update(socket, :collapsed, fn val -> !val end)}
  end

  def handle_event("show_settings", _params, socket) do
    send(self(), {:switch_page, :settings})
    {:noreply, socket}
  end
end
