defmodule Propellant do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(nil) do
    cmd = Path.join([__DIR__, "../priv/thrust/ThrustShell.app/Contents/MacOS/ThrustShell"])
    {:ok, pid, ospid} = :exec.run_link(to_char_list(cmd), [:stdin, :stdout])

    {:ok, event_pid} = GenEvent.start_link

    GenEvent.add_mon_handler event_pid, EventLogger, nil

    {:ok, %{pid: pid,
            ospid: ospid,
            counter: 0,
            waiting: %{},
            buffer: "",
            events: event_pid,
            registered: %{}}}
  end

  @boundary "--(Foo)++__THRUST_SHELL_BOUNDARY__++(Bar)--\n"

  defp send_message(message, from, state) do
    counter = state.counter + 1
    :exec.send(state.ospid,
               Poison.encode!(Map.put(message, :_id, counter)) <> "\n#{@boundary}")
    {:noreply, %{state | waiting: Map.put(state.waiting, counter, from),
                         counter: counter}}
  end

  def handle_call({:create, type, args}, from, state) do
    send_message(%{_action: "create",
                   _type: type,
                   _args: args}, from, state)
  end
  def handle_call({:call, target, method, args}, from, state) do
    send_message(%{_action: "call",
                   _target: target,
                   _method: method,
                   _args: args}, from, state)
  end
  def handle_call({:stop}, _from, state) do
    :exec.stop(state.ospid)
    {:stop, :normal, state}
  end

  def handle_cast({:register, id, item}, state) do
    {:noreply, %{state | registered: Map.put(state.registered, id, item)}}
  end

  def handle_info({:stdout, _, data}, state) do
    handle_chunks(String.split(state.buffer <> data, @boundary), state)
  end
  def handle_chunks([tail], state) do
    {:noreply, %{state | buffer: tail}}
  end
  def handle_chunks([chunk | rest], state) do
    new_state = handle_message(Poison.decode!(chunk), state)
    handle_chunks(rest, new_state)
  end

  def handle_message(%{"_action" => "reply"}=message, state) do
    GenServer.reply(state.waiting[message["_id"]], message["_result"])
    %{state | waiting: Map.delete(state.waiting, message["_id"])}
  end
  def handle_message(%{"_action" => "event"}=message, state) do
    GenEvent.notify state.events, %{type: message["_type"],
                                    target: state.registered[message["_target"]],
                                    data: message["_event"]}
    state
  end

  def create(browser, type, args, fulfill) do
    result = GenServer.call(browser, {:create, type, args})
    item = fulfill.(result)
    GenServer.cast(browser, {:register, item.id, item})
    item
  end

  def stop(pid) do
    GenServer.call(pid, {:stop})
  end
end

defmodule EventLogger do
  use GenEvent
  require Logger

  def handle_event(event, state) do
    Logger.debug inspect(event)
    {:ok, state}
  end
end
