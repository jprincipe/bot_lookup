defmodule BotLookup do
  use GenServer

  # Client API

  def start_link(_opts) do
    case GenServer.start_link(__MODULE__, nil, name: :bot_lookup) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Process.link(pid)
        {:ok, pid}

      :ignore ->
        :ignore
    end
  end

  def bot?(%Plug.Conn{} = conn), do: conn |> get_ua() |> bot?()
  def bot?(nil), do: true
  def bot?(user_agent) when byte_size(user_agent) == 0, do: true
  def bot?(user_agent), do: GenServer.call(:bot_lookup, {:bot?, user_agent})

  def data_file(), do: Path.join(:code.priv_dir(:bot_lookup), "bots.json")

  ## Server Callbacks

  def init(_) do
    {:ok, %{}, {:continue, :load_data}}
  end

  def handle_continue(:load_data, _state) do
    {:noreply, load_data()}
  end

  def handle_call({:bot?, user_agent}, _from, state) do
    if Enum.find(state, &Regex.match?(&1, user_agent)) do
      {:reply, true, state}
    else
      {:reply, false, state}
    end
  end

  defp load_data() do
    data_file()
    |> File.read!()
    |> Jason.decode!()
    |> Enum.map(fn entry ->
      entry |> Map.get("pattern") |> Regex.compile!("i")
    end)
  end

  defp get_ua(conn) do
    Plug.Conn.get_req_header(conn, "user-agent") |> List.first()
  end
end
