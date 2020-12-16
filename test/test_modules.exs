defmodule WorkflowStepOkStageWithTestCase do
  @moduledoc false
  use DarkFlows.Workflow
  step_ok(:step1, with: fn x -> x end)
end

defmodule WorkflowStepOkStageOkWithTestCase do
  @moduledoc false
  use DarkFlows.Workflow
  step_ok(:step1, with: fn x -> {:ok, x} end)
end

defmodule WorkflowStepOkStageFailedWithTestCase do
  @moduledoc false
  use DarkFlows.Workflow
  step_ok(:step1, with: fn _ -> {:error, :failed} end)
end
