defmodule MyEventWeb.UserDashboardLive do
  use MyEventWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_page: :dashboard_overview)}
  end


  def handle_info({:switch_page, page}, socket) do
    {:noreply, assign(socket, current_page: page)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex h-screen">
      <!-- Sidebar on left -->
      <.live_component module={MyEventWeb.SidebarLiveComponent} id="sidebar" />

      <!-- Main content -->
      <main class="flex-1 p-6 overflow-y-auto bg-gray-100 rounded-l-2xl shadow-inner">
        <%= case @current_page do %>
          <% :dashboard_overview -> %>
            <h1 class="text-3xl font-bold text-pink-800 mb-4">Dashboard Overview</h1>
            <p class="text-pink-600">Overview content goes here...</p>

          <% :dashboard_stats -> %>
            <h1 class="text-3xl font-bold text-pink-800 mb-4">Dashboard Stats</h1>
            <p class="text-pink-600">Statistics content goes here...</p>

          <% :settings -> %>
            <h1 class="text-3xl font-bold text-pink-800 mb-4">User Settings</h1>
            <p class="text-pink-600">Settings content goes here...</p>
        <% end %>
      </main>
    </div>
    """
  end
end
