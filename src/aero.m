classdef aero
    methods(Static)
        function a0 = a0_fit(alpha, cl, opts)
            arguments 
                alpha
                cl
                opts.min_alpha (1,1) double = -5
                opts.max_alpha (1,1) double = 10
            end
            % linear region approximate
            idx = (alpha >= opts.min_alpha) & (alpha <= opts.max_alpha);
            
            % linear fit
            p = polyfit(alpha(idx), cl(idx), 1);
            a0_per_deg = p(1);
            a0 = a0_per_deg * (180/pi); % per radian
        end

        function [cl_max, idx] = cl_max(cl)
            [cl_max, idx] = max(cl);
        end

        function [cd_cl_max, idx] = cd_at_cl_max(cl, cd)
            [~, idx] = aero.cl_max(cl);
            cd_cl_max = cd(idx);
        end

        function eta = lift_curve_slope_factor(a0, AR)
            eta = pi * AR / (a0 + pi * AR);
        end

        function CL = CL(cl, eta)
            % three-dimensional lift coefficient
            CL = (2/3) * cl * eta;
        end

        function CDi = induced_drag(CL, e, AR) 
            % induced drag
            CDi = CL^2 / (pi * e * AR);
        end

        function CD = CD(cd, CL, e, AR)
            % drag coefficient
            CDi = aero.induced_drag(CL, e, AR);
            CD = cd + CDi;
        end

        function W0 = init_W0_mass(m_fuel0, m_body, g)
            W0 = (m_body + m_fuel0) * g;
        end

        function W0 = init_W0_perc(perc_fuel_max, m_body, m_fuel_max, g)
            W0 = (m_body + perc_fuel_max * m_fuel_max) * g;
        end

        function V_to = takeoff_velocity(W0, rho, S, CL_max)
            V_to = 1.2 * sqrt(2 * W0 / (rho * S * CL_max));
        end

        function D = D(V, CD, rho, S)
            D = (1/2) * rho * V^2 * S * CD;
        end

        function T = thrust(D, W, gamma)
            % thrust requirement
            T = D + W * sind(gamma);
        end
    end
end