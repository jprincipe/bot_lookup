defmodule BotLookupTest do
  use ExUnit.Case

  setup do
    start_supervised!(BotLookup)

    :ok
  end

  test "validate nil user agent returns true" do
    assert BotLookup.bot?(nil)
  end

  test "validate empty user agent returns true" do
    assert BotLookup.bot?("")
  end

  test "validate real user agent returns false" do
    refute BotLookup.bot?("Real User Agent")
  end

  test "validate conn with user-agent set" do
    conn = Plug.Conn.put_req_header(%Plug.Conn{}, "user-agent", "test-user-agent")

    refute BotLookup.bot?(conn)
  end

  test "validate conn without user-agent set" do
    conn = %Plug.Conn{}

    assert BotLookup.bot?(conn)
  end

  test "validate conn without user-agent set to empty" do
    conn = Plug.Conn.put_req_header(%Plug.Conn{}, "user-agent", "")

    assert BotLookup.bot?(conn)
  end

  test "validate all registered bots" do
    BotLookup.data_file()
    |> File.read!()
    |> Jason.decode!()
    |> Enum.each(fn entry ->
      entry
      |> Map.get("instances", [])
      |> Enum.each(fn instance ->
        assert BotLookup.bot?(instance)
      end)
    end)
  end
end
