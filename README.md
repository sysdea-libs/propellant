# Propellant

Elixir bindings to [Thrust](https://github.com/breach/thrust)

## Status

Primordial

## Example

```elixir
defmodule CommandListener do
  use GenEvent
  require Logger

  def handle_event(%{type: "execute", target: target,
                     data: %{"command_id" => cid, "event_flags" => flags} }, state) do
    Logger.info "Got command execute #{cid}, flags: #{inspect flags}"
    {:ok, state}
  end
  def handle_event(event, state) do
    Logger.debug "Ignored event #{inspect(event)}"
    {:ok, state}
  end
end

{:ok, pid} = Propellant.start_link

GenEvent.add_mon_handler Propellant.events(pid), CommandListener, nil

submenu1 = Propellant.Menu.create(pid)
|> Propellant.Menu.add_item(%{label: "My Label", command_id: 1})

submenu2 = Propellant.Menu.create(pid)
|> Propellant.Menu.add_item(%{label: "My Label 2", command_id: 2})

menu = Propellant.Menu.create(pid)
|> Propellant.Menu.add_submenu(%{menu_id: submenu1.id, label: "My Menu", command_id: 3})
|> Propellant.Menu.add_submenu(%{menu_id: submenu2.id, label: "My Other Menu", command_id: 4})
|> Propellant.Menu.set_application_menu

Propellant.Window.create(pid, %{root_url: "http://breach.cc"})
|> Propellant.Window.show
|> Propellant.Window.focus
```
