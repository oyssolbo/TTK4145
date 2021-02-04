defmodule Elevator do
  @moduledoc """
  The module for the elevator

  At least three such modules will cooperate with
  each other on the lab
  """

  use GenServer

  defstruct [:elevator_state, :elevator_data]

  use Fsmx.Struct, transitions: %{
    "STATE_IDLE" => :*
    "STATE_EMERGENCY" => ["STATE_REDUNDANCY",
            "STATE_IDLE"]
    "STATE_MOVING_UP" => :*
    "STATE_MOVING_DOWN" => :*
    "STATE_LOST_COM" => ["STATE_EMERGENCY",
            "STATE_CHECK_REDUNDANCY"]
    "STATE_CHECK_REDUNDANCY" => :*
  }
  # Transition between state by using
  # struct = Elevator.
  # Fsmx.transition()

  # Must be pattern matched with all of the possible states...
  defp mutate_before_transition(struct, "STATE_EMERGENCY", _destination_state) do
    {:ok, %{struct | elevator_data: %{foo: :bar}}}
  end

  @doc """
  The elevator's FSM. Returns the action that the elevator must perform
  """
  defp elevator_fsm() do
    guards = elevator_guards()

    # Switching based on the guard
    case guards.emergency: do
      # Do something
    end
    case guards.order_below: do

    end
    case guards.order_above: do

    end
    case guards.order_at_floor: do

    end

  end

  @doc """
  Guards used to limit the possible transitions to only one
  """
  defp elevator_guards() do
    # Implement some logic behind the choice of these guards

    # Could do something like "def not_nil?(args) when foo do: true/false"
    # instead. By having multiple of such checks, we can build up all of
    # the conditions that we need

    # Important that these guards are mutexes of each other!

    defstruct [
            emergency: false,
            order_below: false,
            order_above: false,
            order_at_floor: false,
            lost_com: false,
            finished_order: false
    ]
  end

  @doc """
  Run the elevator on port
  """
  def elevator_run(port) do
    # Connect on port #port
    # Initialize the state and the state-machine
    elevator_fsm()
  end

end
