defmodule PropellantTest do
  use ExUnit.Case

  test "basic functionality" do
    {:ok, pid} = Propellant.start_link
    window = Propellant.Window.create(pid, %{root_url: "http://google.co.uk"})
    Propellant.Window.show(window)
    assert {:normal, _} = catch_exit(Propellant.stop(pid))
  end
end
