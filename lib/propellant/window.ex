defmodule Propellant.Window do
  defstruct [:browser, :id]

  def create(browser, args) do
    %{"_target" => id} = GenServer.call(browser, {:create, "window", args})
    %Propellant.Window{browser: browser,
                       id: id}
  end

  def show(window) do
    GenServer.call(window.browser, {:call, window.id, "show", %{}})
    window
  end
end
