model Vehicle
  // -- Parameters --
  parameter Real m = 1800 "Mass [kg]";
  parameter Real Cd = 0.3 "Drag Coefficient";
  parameter Real A = 2.2 "Frontal Area [m^2]";
  parameter Real Crr = 0.015 "Rolling Resistance Coefficient";
  parameter Real g = 9.81 "Gravity [m/s^2]";
  parameter Real rho = 1.225 "Air Density [kg/m^3]";

  // -- Inputs from Python Controller --
  input Real F_prop(unit="N") "Propulsion Force";
  input Real F_brake(unit="N") "Braking Force";

  // -- State Variables --
  Real a_x(unit="m/s^2") "Longitudinal Acceleration";
  Real v(start=0, unit="m/s") "Longitudinal Velocity";
  Real x(start=0, unit="m") "Longitudinal Position";

protected
  Real F_aero "Aerodynamic Drag Force";
  Real F_roll "Rolling Resistance Force";

initial equation
  // Set initial conditions for states
  v = 0;
  x = 0;

equation
  // -- Physics Equations --
  // Define derivatives of state variables
  der(v) = a_x;
  der(x) = v;

  // Calculate acceleration from forces (Newton's 2nd Law)
  m * a_x = F_prop - F_brake - F_aero - F_roll;
  
  // Calculate resistive forces
  F_aero = 0.5 * rho * Cd * A * v*abs(v); // Use v*abs(v) for stability at reverse speeds
  F_roll = Crr * m * g;

end Vehicle;
