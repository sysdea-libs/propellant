defmodule PropellantTest do
  use ExUnit.Case

  test "basic functionality" do
    {:ok, pid} = Propellant.start_link
  end
end
