defmodule Propellant.Menu do
  import Propellant.Base

  defstruct [:browser, :id]

  def create(browser, args \\ %{}) do
    Propellant.create browser, "menu", args, fn %{"_target" => id} ->
      %Propellant.Menu{browser: browser,
                       id: id}
    end
  end

  defmethod :add_item
  defmethod :add_check_item
  defmethod :add_radio_item
  defmethod :add_separator
  defmethod :set_checked
  defmethod :set_enabled
  defmethod :set_visible
  defmethod :set_accelerator
  defmethod :add_submenu
  defmethod :clear
  defmethod :popup
  defmethod :set_application_menu
end
