defmodule Elevator do
  @moduledoc """
  The module for the elevator

  At least three such modules will cooperate with
  each other on the lab
  """

  use # module for TCP or UDP #GenServer

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
    # Takes in the struct of elevator-state/condition whatever and changes one spesific variable
    # in the struct before changing the state/condition/whatever. Changes the structs element foo (for
    # example order_above: to :true)

    {:ok, %{struct | elevator_data: %{foo: :bar}}}
  end

  @doc """
  The elevator's FSM. Returns the action that the elevator must perform
  """
  defp elevator_fsm() do
    guards = elevator_get_guards()

    # Switching based on the guard
    case guards.emergency: do
      mutate_before_transition()
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
  defp elevator_get_guards() do
    # Implement some logic behind the choice of these guards

    # Could do something like "def not_nil?(args) when foo do: true/false"
    # instead. By having multiple of such small function-checks, we can build up all of
    # the conditions that we need and combine them in the greater function elevator_get_guards()

    # Important that these guards are mutexes of each other! We cannot have multiple guards
    # active at the same time. Or we could just

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
  This function gets the action from the state-machine and runs the desired action
  """
  defp elevator_perform_action(struct){
    {:status, :action} = elevator_fsm()
    # Do something with the action
    case :action == :emergency do

    end
    case :action == :go_up do
      # Use driver_elixir.ex for lower level code shit
    end
    case :action == go_down do
      # Use driver_elixir.ex for lower level code shit
    end
    # etc.
  }

  @doc """
  Initializes the elevator

  Unsure whether this should be private or public

  Should be public, such that the elevator is initialized only once, and not every recursion
  in elevator run
  """
  defp elevator_initialize() do
    # Get communication with desired ip-addresses
    # If the elevator is at an undesired floor, run either up or down until we
    # are at a desired floor

    # Set the state to known

    {struct_from_init} = # set to something
  end

  @doc """
  Run the elevator on port
  """
  def elevator_run(port) do
    # Connect on port #port
    # Initialize the state and the state-machine
    {struct_from_init} = elevator_initialize()

    # Get the current state and guards
    elevator_fsm()

    # Do required action
    elevator_perform_action()

    # Run indefinetly
    elevator_run()

  end

end
