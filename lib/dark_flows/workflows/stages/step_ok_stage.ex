defmodule DarkFlows.Workflows.Stages.StepOkStage do
  @moduledoc """
  Adds `:ok` tuple monad handling step to `Opus.Pipeline`.
  """

  alias DarkFlows.Workflow
  alias DarkFlows.Workflows.Stages.StepOkStage

  require Opus.Pipeline

  @type opts() :: Keyword.t()
  @type wrapped_step_ok_fun() :: (Workflow.context() -> Workflow.step_result())

  @type step_result() ::
          Workflow.context()
          | :ok
          | {:ok, Workflow.context()}
          | {:error, any()}
          | {:error, failed_operation :: atom(), failed_value :: any(), changes_so_far :: map()}

  @doc """
  Adds `step_ok` to the `Opus.Pipeline` allowing for `:ok` unboxing
  """
  @spec step_ok(atom(), opts()) :: Macro.t()
  defmacro step_ok(name, opts \\ []) when is_atom(name) do
    fallback_with =
      quote do
        &apply(unquote(__CALLER__.module), unquote(name), [&1])
      end

    quote do
      Opus.Pipeline.step(
        unquote(name),
        unquote(
          for {key, val} <- Keyword.put_new(opts, :with, fallback_with), into: [] do
            case key do
              :with -> {key, quote(do: StepOkStage.wrap_ok(unquote(val)))}
              _ -> {key, val}
            end
          end
        )
      )
    end
  end

  @doc """
  Handles unboxing `:ok` monads for ease-of-use with `Opus.Pipeline`.
  """
  @spec wrap_ok(Workflow.step_fun()) :: wrapped_step_ok_fun()
  def wrap_ok(fun) when is_function(fun, 1) do
    fn context when is_map(context) ->
      result = fun.(context)
      handle_result(context, result)
    end
  end

  @doc """
  Normalize the result of `:ok` monad steps
  """
  @spec handle_result(Workflow.context(), step_result()) :: Workflow.step_result()
  def handle_result(context, :ok) when is_map(context) do
    context
  end

  def handle_result(context, {:ok, results}) when is_map(context) and is_map(results) do
    Map.merge(context, results)
  end

  def handle_result(context, results) when is_map(context) and is_map(results) do
    Map.merge(context, results)
  end

  def handle_result(context, {:error, failed_operation, failed_value, changes_so_far})
      when is_map(context) and is_atom(failed_operation) and is_map(changes_so_far) do
    {:error,
     %{
       failed_operation: failed_operation,
       failed_value: failed_value,
       changes_so_far: changes_so_far
     }}
  end

  def handle_result(context, {:error, failed_value})
      when is_map(context) do
    {:error, failed_value}
  end
end
