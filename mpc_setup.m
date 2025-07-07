% Vehicle parameters
m = 1800;
c_aero = 20.21; % Damping at 25 m/s

% State-space matrices (A,B,C,D) for acceleration dynamics
A = -c_aero/m;
B = 1/m;
C = 1;
D = 0;

% Create the state-space plant model with a 0.01s sample time
plant_model = ss(A, B, C, D, 'Ts', 0.01);

% Create the MPC controller object using the plant model
mpc_controller = mpc(plant_model);

% Add integral action by setting the output disturbance model
setoutdist(mpc_controller, 'model', tf(1,[1 0]));

% --- Set Key Parameters ---

% Set how far the controller looks into the future (e.g., 20 steps = 0.2s)
mpc_controller.PredictionHorizon = 20;

mpc_controller.ControlHorizon = 5;

% Set constraints on the propulsion force (the manipulated variable)
mpc_controller.MV.Min = 0;     % Min force is 0 N
mpc_controller.MV.Max = 10000; % Max force is 10,000 N

% --- Set Tuning and Horizon Parameters ---
