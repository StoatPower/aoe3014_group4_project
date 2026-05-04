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
    
    % max lift
    cl_max = aero.cl_max(cl);
    out.cl_max = cl_max;

    % cd at cl_max
    cd_cl_max = aero.cd_at_cl_max(cl, cd);
    out.cl_cd_max = cd_cl_max;
    
    eta = aero.lift_curve_slope_factor(a0, p.AR);
    out.eta = eta;
    
    % three-dimensional lift coefficient
    CL = aero.CL(cl_max, eta);
    out.CL = CL;
    
    % drag coefficient
    CD = aero.CD(cd_cl_max, CL, p.e, p.AR);
    out.CD = CD;
    
    % Assumed initial weight
    W0 = aero.init_W0_perc(opts.m_fuel_perc, p.m_body, p.m_fuel_max, p.g);
    out.W0 = W0;
    
    % takeoff velocity
    V_to = aero.takeoff_velocity(W0, CL, p.rho_ORD, p.S);
    out.V_to = V_to;
    
    % drag
    D = aero.D(V_to, CD, p.rho_ORD, p.S);
    out.D = D;
    
    % thrust requirement
    T = aero.thrust(D, W0, 0);
    out.T = T;

end



