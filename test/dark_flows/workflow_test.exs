defmodule DarkFlows.WorkflowTest do
  @moduledoc false
  use ExUnit.Case, async: true
  doctest DarkFlows.Workflow
  alias DarkFlows.Workflow

  describe ".partial_get_in/2" do
    test "given a valid selector and fun 1" do
      fun = fn
        :selector_used -> :found
        _ -> :error
      end

      selector = :selector
      context = %{selector => :selector_used}

      partial = Workflow.partial_get_in(selector, fun)
      assert is_function(partial, 1)
      assert fun.(context) == :error
      assert partial.(context) == :found
    end
  end
end
