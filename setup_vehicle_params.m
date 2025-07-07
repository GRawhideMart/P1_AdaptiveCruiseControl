% Script to define Ego Vehicle parameters

m = 1800;         % Vehicle Mass [kg]
g = 9.81;         % Gravitational acceleration [m/s^2]

% Aerodynamic Parameters
rho = 1.225;      % Air density [kg/m^3]
Cd = 0.3;         % Drag coefficient
A = 2.2;          % Frontal area [m^2]

% Rolling Resistance
Crr = 0.015;      % Rolling resistance coefficient

% Initial Conditions
V0 = 0;           % Initial velocity [m/s]
X0 = 0;           % Initial position [m]
X0_lead = 150;    % Initial position of lead vehicle [m]