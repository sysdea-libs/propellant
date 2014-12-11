defmodule Propellant.Window do
  import Propellant.Base

  defstruct [:browser, :id]

  def create(browser, args \\ %{}) do
    Propellant.create browser, "window", args, fn %{"_target" => id} ->
      %Propellant.Window{browser: browser,
                         id: id}
    end
  end

  defmethod :show
  defmethod :focus
  defmethod :maximize
  defmethod :minimize
  defmethod :restore
  defmethod :set_title
  defmethod :set_fullscreen
  defmethod :set_kiosk
  defmethod :open_devtools
  defmethod :close_devtools
  defmethod :move
  defmethod :resize
  defmethod :remote

  defaccessor :is_closed
  defaccessor :size
  defaccessor :is_maximized
  defaccessor :is_minimized
  defaccessor :is_fullscreen
  defaccessor :is_kiosed
  defaccessor :is_devtools_opened
end
