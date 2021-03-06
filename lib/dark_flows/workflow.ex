defmodule DarkFlows.Workflow do
  @moduledoc """
  `DarkFlows.Workflow`
  """
  @moduledoc since: "1.0.0"

  alias Opus.PipelineError

  alias DarkFlows.Workflows.Stages.StepOkStage

  @type opts() :: Keyword.t()
  @type context() ::
          map()
          | %{required(atom()) => any()}
          | %{required(String.t()) => any()}

  @type step_fun() :: (any() -> any())
  @type step_result() ::
          context()
          | {:error, atom()}
          | {:error, failed_multi()}
          | {:error, any()}

  @type result() ::
          {:ok, context()}
          | {:error, PipelineError.t()}

  @type failed_multi() :: %{
          failed_operation: atom(),
          failed_value: any(),
          changes_so_far: map()
        }

  @doc false
  @spec __using__(opts()) :: Macro.t()
  defmacro __using__(_opts \\ []) do
    quote location: :keep do
      use Opus.Pipeline

      import DarkFlows.Workflow, only: [within: 2]
      import StepOkStage, only: [step_ok: 1, step_ok: 2]
    end
  end

  @doc """
  Helper for extracting a context value via partial application.
  """
  @spec within(atom(), step_fun()) :: (context() -> any())
  def within(selector, fun) when is_atom(selector) and is_function(fun, 1) do
    fn context when is_map(context) ->
      context
      |> Map.get(selector)
      |> fun.()
    end
  end
end
