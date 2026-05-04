function base = takeoff_base(polars_path)
    % data from XFoil polars file  
    pol = readmatrix(polars_path,'FileType','text');
    alpha = pol(:,1); % angle of attack (deg)
    cl = pol(:,2); % lift coefficient
    cd = pol(:,3); % drag coefficient
    
    % project parameters
    p = params();
    
    % base takeoff calculations
    base.a0 = aero.a0_fit(alpha, cl); % estimate lift curve slope        
    base.cl_max = aero.cl_max(cl);% 2D max lift
    base.cd_cl_max = aero.cd_at_cl_max(cl, cd); % 2D cd at cl_max
    base.eta = aero.lift_curve_slope_factor(base.a0, p.AR);
    base.CL_max = aero.CL(base.cl_max, base.eta); % 3D CL max
    base.CD_max = aero.CD(base.cd_cl_max, base.CL_max, p.e, p.AR); % 3D CD max
    base.CL = base.CL_max; % 3D CL is at 3D CL_max for takeoff
    base.CD = base.CD_max; % 3D CD is at 3D CD_max for takeoff   
    
    % 
    % % Assumed initial weight
    % W0 = aero.init_W0_perc(opts.m_fuel_perc, p.m_body, p.m_fuel_max, p.g);
    % out.W0 = W0;
    % 
    % % takeoff velocity
    % V_to = aero.takeoff_velocity(W0, p.rho_ORD, p.S, CL_max);
    % out.V_to = V_to;
    % 
    % % total lift
    % L = aero.L(V_to, CL, p.rho_ORD, p.S);
    % out.L = L;
    % 
    % % total drag
    % D = aero.D(V_to, CD, p.rho_ORD, p.S);
    % out.D = D;
    % 
    % % take off thrust = max thrust
    % T_to = p.T_max;
    % out.T_to = T_to;
    % 
    % % takeoff distance with rolling friction
    % x_to = aero.x_to(V_to, CL_max, CD_max, T_to, W0, p.rho_ORD, p.S, p.g, p.mu_r);
    % out.x_to = x_to;
    % 
    % % takeoff distance without rolling friction
    % % x_to_no_fric = aero.x_to(V_to, CL_max, CD_max, T_to, W0, p.rho_ORD, p.S, p.g, 0);
    % % out.x_to_no_fric = x_to_no_fric;
    % 
    % % takeoff time with rolling friction
    % t_to = aero.t_takeoff(x_to, V_to);
    % out.t_to = t_to;
    % 
    % % takeoff time without rolling friction
    % % t_to_no_fric = aero.t_takeoff(x_to_no_fric, V_to);
    % % out.t_to_no_fric = t_to_no_fric;
    % 
    % % mass flow rate 
    % mf_rate_to = aero.mass_flow_rate(T_to, p.SFC);
    % out.mf_rate_to = mf_rate_to;
    % 
    % % mass flow total
    % mf_total_to = aero.mass_flow_total(mf_rate_to, t_to);
    % out.mf_total_to = mf_total_to;
    % 
    % % final weight at take off
    % W_to = W0 - mf_total_to*p.g;
    % out.W_to = W_to;
end



