defmodule Propellant.Window do
  defstruct [:browser, :id]

  def create(browser, args) do
    Propellant.create browser, "window", args, fn %{"_target" => id} ->
      %Propellant.Window{browser: browser,
                         id: id}
    end
  end

  def show(window) do
    GenServer.call(window.browser, {:call, window.id, "show", %{}})
    window
  end
end
