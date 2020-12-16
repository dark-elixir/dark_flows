defmodule DarkFlows.Workflows.Stages.StepOkStageTest do
  @moduledoc false
  use ExUnit.Case, async: true
  doctest DarkFlows.Workflows.Stages.StepOkStage
  alias DarkFlows.Workflows.Stages.StepOkStage

  describe ".step_ok/2" do
    setup _tags do
      [context: %{}]
    end

    test "given WorkflowStepOkStageWithTestCase it returns :ok", %{context: context} do
      assert WorkflowStepOkStageWithTestCase.call(context) == {:ok, context}
    end

    test "given WorkflowStepOkStageOkWithTestCase it returns :ok", %{context: context} do
      assert WorkflowStepOkStageOkWithTestCase.call(context) == {:ok, context}
    end

    test "given WorkflowStepOkStageFailedWithTestCase it returns :error", %{context: context} do
      assert WorkflowStepOkStageFailedWithTestCase.call(context) ==
               {:error,
                %Opus.PipelineError{
                  error: :failed,
                  input: %{},
                  pipeline: WorkflowStepOkStageFailedWithTestCase,
                  stacktrace: nil,
                  stage: :step1
                }}
    end
  end

  describe ".wrap_ok/1" do
    setup _tags do
      [context: %{}]
    end

    test "given a valid fun/1 that returns a map", %{context: context} do
      fun = fn x -> x end
      wrapped_fun = StepOkStage.wrap_ok(fun)

      assert is_function(fun, 1)
      assert is_function(wrapped_fun, 1)

      assert fun.(context) == context
      assert wrapped_fun.(context) == context
    end

    test "given a valid fun/1 that returns {:error, :failed}", %{context: context} do
      error = {:error, :failed}
      fun = fn _ -> error end
      wrapped_fun = StepOkStage.wrap_ok(fun)

      assert is_function(fun, 1)
      assert is_function(wrapped_fun, 1)

      assert fun.(context) == error
      assert wrapped_fun.(context) == error
    end

    test "given a valid fun/1 that returns {:error, :failed_operation, :failed_value, %{changes_so_far: true}}",
         %{context: context} do
      error = {:error, :failed_operation, :failed_value, %{changes_so_far: true}}
      fun = fn _ -> error end
      wrapped_fun = StepOkStage.wrap_ok(fun)

      assert is_function(fun, 1)
      assert is_function(wrapped_fun, 1)

      assert fun.(context) == error

      assert wrapped_fun.(context) ==
               {:error,
                %{
                  failed_operation: elem(error, 1),
                  failed_value: elem(error, 2),
                  changes_so_far: elem(error, 3)
                }}
    end
  end

  describe ".handle_result/2 (valid cases)" do
    setup _tags do
      [context: %{}]
    end

    test "given a valid context and :ok", %{context: context} do
      results = :ok
      assert StepOkStage.handle_result(context, results) == context
    end

    test "given a valid context and {:ok, map()}", %{context: context} do
      results = {:ok, %{map: true}}
      assert StepOkStage.handle_result(context, results) == Map.merge(context, elem(results, 1))
    end

    test "given a valid context and {:error, atom()}", %{context: context} do
      results = {:error, :reason}
      assert StepOkStage.handle_result(context, results) == results
    end

    test "given a valid context and {:error, map()}", %{context: context} do
      results = {:error, %{map: true}}
      assert StepOkStage.handle_result(context, results) == results
    end

    test "given a valid context and {:error, failed_operation(), failed_value(), changes_so_far()}",
         %{context: context} do
      results = {:error, :failed_operation, :failed_value, %{changes_so_far: true}}

      assert StepOkStage.handle_result(context, results) ==
               {:error,
                %{
                  failed_operation: elem(results, 1),
                  failed_value: elem(results, 2),
                  changes_so_far: elem(results, 3)
                }}
    end
  end

  describe ".handle_result/2 (unsupported cases)" do
    setup _tags do
      [context: %{}]
    end

    test "given a valid context and :error", %{context: context} do
      results = :error

      assert_raise FunctionClauseError,
                   "no function clause matching in DarkFlows.Workflows.Stages.StepOkStage.handle_result/2",
                   fn ->
                     StepOkStage.handle_result(context, results)
                   end
    end
  end
end
