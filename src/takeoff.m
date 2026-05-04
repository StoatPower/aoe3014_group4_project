clear; 
clc;

%============Read Data=================
Data = readmatrix('..\data\outputs\clean.pol','FileType','text');

% read in project parameters
p = params();

alpha = Data(:,1); % angle of attack (deg)
cl = Data(:,2); % lift coefficient
cd = Data(:,3); % drag coefficient

% estimate lift curve slope
a0 = aero.a0_fit(alpha, cl)

% % % max 3d profile lift
cl_max = aero.cl_max(cl)
% % plot
% plot(alpha, cl, 'o-')
% grid on
% xlabel('\alpha (deg)')
% ylabel('C_l')
% title('Lift Curve')

cd_cl_max = aero.cd_at_cl_max(cl, cd)

eta = aero.lift_curve_slope_factor(a0, p.AR)

% three-dimensional lift coefficient
CL = aero.CL(cl_max, eta)

% drag coefficient
CD = aero.CD(cd_cl_max, CL, p.e, p.AR)

% Assumed initial weight
W0 = aero.init_W0_mass(50000, p.m_body, p.g)

% takeoff velocity
V_to = aero.takeoff_velocity(W0, CL, p.rho_ORD, p.S)

% drag
D = aero.D(V_to, CD, p.rho_ORD, p.S)

% thrust requirement
T = aero.thrust(D, W0, 0)


