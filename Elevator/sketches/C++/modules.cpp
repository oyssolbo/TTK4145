/**
 * @brief Modules and definitions that could be nice to have
 * 
 * This is mostly used by me to get an idea of the problem. There must be further implementations in Erlang/Elixir,
 * however the overhead of the functions would be equivalent.  
 */

#include <string>
using namespace std;

#define NUM_FLOORS 4
#define NUM_ELEVATORS 3
#define NUM_MASTERS 2

#define DOOR_TIMER 3                /* Time the door is open in seconds */
#define CONNECTION_TIMEOUT 0.1      /* Time between checking for connection problems */


enum State_elevator{
  STATE_ELEVATOR_IDLE, 
  STATE_ELEVATOR_MOVING_UP, 
  STATE_ELEVATOR_MOVING_DOWN, 
  STATE_ELEVATOR_EMERGENCY,
  STATE_ELEVATOR_OPEN_DOOR
};


enum Action_elevator{
  ACTION_ELEVATOR_ENGINE_UP,
  ACTION_ELEVATOR_ENGINE_DOWN,
  ACTION_ELEVATOR_ENGINE_STOP,
  ACTION_ELEVATOR_OPEN_DOOR,
  ACTION_ELEVATOR_CLOSE_DOOR,
  ACTION_ELEVATOR_START_TIMER,
  ACTION_EMERGENCY
};


class Connection{
private:
  string IP_address;
  string connected_IP_addresses[NUM_ELEVATORS + NUM_MASTERS];

public:
  /* Constructor and destructor */
  Connection(const string& IP_address);
  ~Connection();

  /* Connection-functions */
  bool check_connection(const string& IP_address);
  void establish_connection(const string& IP_address);
  void terminate_connection(const string& IP_address);

  /* Recieve and transmit data */
  char* listen();
  void transmit_over_connection(const string& IP_address, char* data);
  void broadcast(char* data);
};


class Order{
private:
  int orders_up[NUM_FLOORS];        /* Orders going up */
  int orders_down[NUM_FLOORS];      /* Orders going down */

public:
  /* Order-functions */
  void set_order();
  void clear_order();

};


/* Can be used if required to send data to the master */
struct Elevator_info{
  int current_floor;
  State_elevator current_state;
};


class Elevator{
private:
  Elevator_info elevator_state;     /* Struct containing current floor and current elevator_state */
  time_t timer;                     /* The timer-object used to describe when the door opened */
  Connection master_connections;    /* External connections */
  Order elevator_orders;            /* Orders the elevator must perform. If lost connection, the elevator will continue finishing the orders */

  /* FSM */
  Action_elevator elevator_fsm();

  /* Perform current action from the FSM */
  bool elevator_perform_action(const Action_elevator& action_elevator);

  /* Control the elevator's queue/order */
  void control_orders(); // Terrible name, though

  /* Broadcast status */
  void broadcast_elevator_status(); // Should be done by the connection-class

public:
  /* Constructor and destructor */
  Elevator();
  ~Elevator();

};



class Master{
private:
  Connection elevator_connections;  /* Connection to the elevators */
  Connection master_connections;    /* Connection to the other master(s) (if we go for it) */
  Order orders;                     /* The total  */

  /* Share orders with the other master */
  void share_orders();

  /* Check for new orders and add to @p orders if detected */
  void check_new_orders();

  /* Calculate which elevator to be given what order. Send to that spesific elevator */
  void assign_order_to_elevators();

public:
  /* Constructor and destructor */
  Master();
  ~Master();

};

















