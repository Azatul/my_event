defmodule MyEvent.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

    def change do
      alter table(:users) do
        add :full_name, :string
        add :bio, :text
        add :phone_number, :string
        add :department, :string
      end
    end
end
