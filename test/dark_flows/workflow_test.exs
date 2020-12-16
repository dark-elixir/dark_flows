defmodule DarkFlows.WorkflowTest do
  @moduledoc false
  use ExUnit.Case, async: true
  doctest DarkFlows.Workflow
  alias DarkFlows.Workflow

  describe ".partial_get_in/2" do
    test "given a valid selector and fun 1" do
      selector = :selector
      context = %{selector => :selector_used}

      fun = fn
        :selector_used -> :found
        _ -> :error
      end

      partial = Workflow.partial_get_in(selector, fun)
      assert is_function(partial, 1)
      assert fun.(context) == :error
      assert partial.(context) == :found
    end
  end

  describe ".within/2" do
    test "given a valid selector and fun 1" do
      selector = :selector

      fun = fn
        :selector_used -> :found
        _ -> :error
      end

      assert {:with, partial} = Workflow.within(selector, fun)
      assert is_function(partial, 1)
    end
  end
end
