defmodule MyEventWeb.AdminLoginLive do
  use MyEventWeb, :live_view

  def render(assigns) do
    ~H"""
<div class="mx-auto max-w-sm bg-pink-50 p-6 rounded-xl shadow-md space-y-6">
  <.header class="text-center text-pink-800">
    Log in to your admin account
  </.header>

  <.simple_form
    for={@form}
    id="login_form"
    action={~p"/admins/log_in"}
    phx-update="ignore"
    class="space-y-4"
  >
    <.input
      field={@form[:email]}
      type="email"
      label="Email"
      class="rounded-lg border-pink-300 focus:border-pink-500"
      required
    />
    <.input
      field={@form[:password]}
      type="password"
      label="Password"
      class="rounded-lg border-pink-300 focus:border-pink-500"
      required
    />

    <:actions>
      <div class="flex items-center justify-between">
        <.input
          field={@form[:remember_me]}
          type="checkbox"
          label="Keep me logged in"
          class="text-pink-600"
        />
        <.link href={~p"/admins/reset_password"} class="text-sm font-semibold text-pink-600 hover:underline">
          Forgot password?
        </.link>
      </div>
    </:actions>

    <:actions>
      <.button phx-disable-with="Logging in..." class="w-full bg-pink-500 hover:bg-pink-600 text-white font-semibold py-2 rounded-lg shadow-sm">
        Log in <span aria-hidden="true">→</span>
      </.button>
    </:actions>
  </.simple_form>
</div>
"""
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "admin")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
