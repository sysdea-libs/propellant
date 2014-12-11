defmodule Propellant.Session do
  defstruct [:browser, :id]

  def create(browser, args) do
    Propellant.create browser, "session", args, fn %{"_target" => id} ->
      %Propellant.Session{browser: browser,
                         id: id}
    end
  end
end
