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
end



