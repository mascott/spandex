defmodule Spandex.Datadog.Api do
  @moduledoc """
  Provides functions for communicating with a datadog service using the apm api.

  This adapter uses msgpack of json for performance reasons, which is the preference
  of the datadog APM api as well. See the api documentation for more information:
  https://docs.datadoghq.com/tracing-api/
  """

  @doc """
  Creates a trace in datadog API, which in reality is just a list of spans
  """
  @spec create_trace([map]) :: {:ok, HTTPoison.Response.t | HTTPoison.AsyncResponse.t} | {:error, HTTPoison.Error.t} | :disabled
  def create_trace(spans) do
    if Spandex.disabled?() do
      :disabled
    else
      adapter =
        :spandex
        |> Confex.get_env(:datadog)
        |> Keyword.get(:api_adapter, Spandex.Datadog.ApiServer)

      adapter.send_spans(spans)
    end
  end
end
