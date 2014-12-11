defmodule Propellant.Session do
  import Propellant.Base

  defstruct [:browser, :id]

  def create(browser, args \\ %{}) do
    Propellant.create browser, "session", args, fn %{"_target" => id} ->
      %Propellant.Session{browser: browser,
                         id: id}
    end
  end

  defmethod :visitedlink_add
  defmethod :proxy_set
  defmethod :proxy_clear

  defaccessor :is_off_the_record
end
