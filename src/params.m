function p = params()
    % Constants
    p.g = 9.80665;              % m/s^2
    p.rho_SL = 1.225;           % kg/m^3
    p.alt_ORD = 204;            % m
    p.alt_MIA = 3;              % m
    [~, ~, ~, p.rho_ORD] = atmosisa(p.alt_ORD); % kg/m^3
    [~, ~, ~, p.rho_MIA] = atmosisa(p.alt_MIA); % kg/m^3
    
    % Aircraft geometry
    p.b = 79.8;                 % m
    p.S = 845;                  % m^2
    p.c = p.S / p.b;            % m
    p.AR = p.b^2 / p.S;
    
    % Aircraft mass
    p.m_body = 277000;          % kg
    p.m_fuel_max = 257000;      % kg
    p.m_takeoff_max = 575000;   % kg
    
    % Thrust / fuel / avg rolling friction
    p.T_max_lbf = 140000;       % lbf
    p.T_max = p.T_max_lbf * 4.4482216153; % N
    p.mu_r = 0.03;
    
    p.SFC_lbf = 0.5;            % lbm fuel / (lbf thrust * hr)
    
    % Convert SFC to SI: kg fuel / (N thrust * s)
    p.SFC = p.SFC_lbf ...
        * 0.45359237 ...        % lbm -> kg
        / 4.4482216153 ...      % lbf -> N
        / 3600;                 % hr -> s
    
    % Aerodynamic correction constants
    p.e = 1 / (1 + 1/8);        % span efficiency
    
    % Mission constraints
    p.R_max = 1927e3;           % m
    p.x_ORD = 13000 * 0.3048;  % m
    p.x_MIA = 13016 * 0.3048;  % m
    
    % Default design variables
    p.gamma_climb = deg2rad(3);
    p.gamma_desc = deg2rad(3);
    p.h_cruise = 11000;         % m
    p.m_fuel0 = 180000;         % kg
end