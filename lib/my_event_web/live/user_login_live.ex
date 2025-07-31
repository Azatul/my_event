defmodule MyEventWeb.UserLoginLive do
  use MyEventWeb, :live_view

  def render(assigns) do
    ~H"""
<div class="mx-auto max-w-sm bg-indigo-50 p-6 rounded-xl shadow-md space-y-6">
  <.header class="text-center text-indigo-800">
    Log in to your account
    <:subtitle>
      Don't have an account?
      <.link navigate={~p"/users/register"} class="font-semibold text-indigo-600 hover:underline">
        Sign up
      </.link>
      for an account now.
    </:subtitle>
  </.header>

  <.simple_form
    for={@form}
    id="login_form"
    action={~p"/users/log_in"}
    phx-update="ignore"
    class="space-y-4"
  >
    <.input
      field={@form[:email]}
      type="email"
      label="Email"
      class="rounded-lg border-indigo-300 focus:border-indigo-500"
      required
    />
    <.input
      field={@form[:password]}
      type="password"
      label="Password"
      class="rounded-lg border-indigo-300 focus:border-indigo-500"
      required
    />

    <:actions>
      <div class="flex items-center justify-between">
        <.input
          field={@form[:remember_me]}
          type="checkbox"
          label="Keep me logged in"
          class="text-indigo-600"
        />
        <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-indigo-600 hover:underline">
          Forgot your password?
        </.link>
      </div>
    </:actions>

    <:actions>
      <.button phx-disable-with="Logging in..." class="w-full bg-indigo-500 hover:bg-indigo-600 text-white font-semibold py-2 rounded-lg shadow-sm">
        Log in <span aria-hidden="true">→</span>
      </.button>
    </:actions>
  </.simple_form>
</div>
"""

  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
