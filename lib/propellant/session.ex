defmodule Propellant.Session do
  defstruct [:browser, :id]

  def create(browser, args) do
    %{"_target" => id} = GenServer.call(browser, {:create, "session", args})
    %Propellant.Session{browser: browser,
                        id: id}
  end
end
