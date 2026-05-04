function out = takeoff(polars_path, opts)
    arguments
        polars_path,
        opts.m_fuel_perc (1,1) double = 0.5
    end
    % data from XFoil polars file
    pol = readmatrix(polars_path,'FileType','text');
    
    % project parameters
    p = params();
    
    alpha = pol(:,1); % angle of attack (deg)
    cl = pol(:,2); % lift coefficient
    cd = pol(:,3); % drag coefficient
    
    % estimate lift curve slope
    a0 = aero.a0_fit(alpha, cl);
    out.a0 = a0;
    
    % 2D max lift
    cl_max = aero.cl_max(cl);
    out.cl_max = cl_max;

    % 2D cd at cl_max
    cd_cl_max = aero.cd_at_cl_max(cl, cd);
    out.cd_cl_max = cd_cl_max;
    
    eta = aero.lift_curve_slope_factor(a0, p.AR);
    out.eta = eta;

    % 3D CL max
    CL_max = aero.CL(cl_max, eta);
    out.CL_max = CL_max;
    
    % 3D CD max
    CD_max = aero.CD(cd_cl_max, CL_max, p.e, p.AR);
    out.CD_max = CD_max;

    % 3D CL is at 3D CL_max for takeoff
    CL = CL_max;
    out.CL = CL;

    % 3D CD is at 3D CD_max for takeoff
    CD = CD_max;
    out.CD = CD;
    
    % Assumed initial weight
    W0 = aero.init_W0_perc(opts.m_fuel_perc, p.m_body, p.m_fuel_max, p.g);
    out.W0 = W0;
    
    % takeoff velocity
    V_to = aero.takeoff_velocity(W0, p.rho_ORD, p.S, CL_max);
    out.V_to = V_to;
    
    % total lift
    L = aero.L(V_to, CL, p.rho_ORD, p.S);
    out.L = L;

    % total drag
    D = aero.D(V_to, CD, p.rho_ORD, p.S);
    out.D = D;
    
    % thrust requirement
    T = aero.thrust(D, W0, 0);
    out.T = T;

    % thrust under T_max?
    out.T_lt_Tmax = (T <= p.T_max);

    % takeoff distance
    x_to = aero.x_to(V_to, L, D, p.T_max, W0, p.mu_r, p.g);
    out.x_to = x_to;

    % 
end



