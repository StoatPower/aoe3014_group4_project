function tbl = takeoff_sweep(polars_path, fuel_fracs)
    arguments
        polars_path,
        fuel_fracs double = linspace(0.10, 1.00, 91)
    end

    p = params();
    base = takeoff_base(polars_path);

    n = numel(fuel_fracs);
    rows = repmat(struct(), n, 1);

    for i = 1:n
        f = fuel_fracs(i);

        W0 = aero.init_W0_perc(f, p.m_body, p.m_fuel_max, p.g);
        V_to = aero.takeoff_velocity(W0, p.rho_ORD, p.S, base.CL_max);

        L = aero.L(V_to, base.CL_max, p.rho_ORD, p.S);
        D = aero.D(V_to, base.CD_max, p.rho_ORD, p.S);

        T_to = p.T_max;
        x_to = aero.x_to(V_to, base.CL_max, base.CD_max, T_to, W0, ...
                         p.rho_ORD, p.S, p.g, p.mu_r);

        t_to = aero.t_takeoff(x_to, V_to);
        mf_rate_to = aero.mass_flow_rate(T_to, p.SFC);
        mf_total_to = aero.mass_flow_total(mf_rate_to, t_to);
        W_to = W0 - mf_total_to*p.g;

        rows(i).fuel_frac = f;
        rows(i).fuel_percent = 100*f;
        rows(i).fuel_mass_kg = p.m_fuel_max*f; 

        rows(i).a0 = base.a0;
        rows(i).cl_max = base.cl_max;
        rows(i).cd_cl_max = base.cd_cl_max;
        rows(i).eta = base.eta;
        rows(i).CL_max = base.CL_max;
        rows(i).CD_max = base.CD_max;

        rows(i).W0_N = W0;
        rows(i).m0_kg = W0 / p.g;
        rows(i).V_to_mps = V_to;
        rows(i).V_to_kts = V_to * 1.94384;

        rows(i).L_N = L;
        rows(i).D_N = D;
        rows(i).T_to_N = T_to;

        rows(i).x_to_m = x_to;
        rows(i).x_to_ft = x_to * 3.28084;
        rows(i).runway_ok = x_to <= p.x_ORD;

        rows(i).t_to_s = t_to;
        rows(i).mf_rate_to = mf_rate_to;
        rows(i).mf_total_to = mf_total_to;
        rows(i).W_to_N = W_to;
    end

    tbl = struct2table(rows);
    tbl = sortrows(tbl, "fuel_frac", "descend");
end