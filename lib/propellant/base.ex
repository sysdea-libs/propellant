defmodule Propellant.Base do
  defmacro defmethod(name) do
    quote do
      def unquote(name)(struct, args \\ %{}) do
        GenServer.call(struct.browser,
                       {:call, struct.id, unquote(Atom.to_string(name)), args})
        struct
      end
    end
  end

  defmacro defaccessor(name) do
    strname = Atom.to_string(name)
    accessor = String.split(strname, "_") |> List.last

    quote do
      def unquote(name)(struct) do
        res = GenServer.call(struct.browser,
                             {:call, struct.id, unquote(strname), %{}})
        res[unquote(accessor)]
      end
    end
  end
end
