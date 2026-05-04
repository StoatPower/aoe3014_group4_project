classdef aero
    methods(Static)
        function a0 = a0_fit(alpha, cl, opts)
            %A0_FIT Estimate 2D lift-curve slope from a linear alpha range.
            %   Returns a0 = dcl/dalpha in units of 1/radian.
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
            %CL_MAX Find maximum 2D sectional lift coefficient.
            %   Returns cl_max and its index in the XFOIL polar.
            [cl_max, idx] = max(cl);
        end

        function [cd_cl_max, idx] = cd_at_cl_max(cl, cd)
            %CD_AT_CL_MAX Find 2D sectional drag at maximum sectional lift.
            %   Returns cd at the same index where cl is maximum.
            [~, idx] = aero.cl_max(cl);
            cd_cl_max = cd(idx);
        end

        function eta = lift_curve_slope_factor(a0, AR)
            %LIFT_CURVE_SLOPE_FACTOR Compute finite-wing lift correction factor.
            %   Uses a0 in 1/radian.
            eta = pi * AR / (a0 + pi * AR);
        end

        function CL = CL(cl, eta)
            %CL Convert 2D sectional lift coefficient to 3D aircraft lift coefficient.
            CL = (2/3) * cl * eta;
        end

        function CDi = induced_drag(CL, e, AR) 
            %INDUCED_DRAG Compute finite-wing induced drag coefficient.
            CDi = CL^2 / (pi * e * AR);
        end

        function CD = CD(cd, CL, e, AR)
            %CD Convert 2D sectional drag to 3D aircraft drag coefficient.
            %   Adds induced drag to the XFOIL sectional/profile drag.
            CDi = aero.induced_drag(CL, e, AR);
            CD = cd + CDi;
        end

        function W0 = init_W0_mass(m_fuel0, m_body, g)
            %INIT_W0_MASS Compute initial aircraft weight from fuel and body mass.
            W0 = (m_body + m_fuel0) * g;
        end

        function W0 = init_W0_perc(perc_fuel_max, m_body, m_fuel_max, g)
            %INIT_W0_PERC Compute initial aircraft weight from fuel fraction.
            %   perc_fuel_max should be given as a decimal fraction, e.g. 0.75.
            W0 = (m_body + perc_fuel_max * m_fuel_max) * g;
        end

        function V_to = takeoff_velocity(W0, rho, S, CL_max)
            %TAKEOFF_VELOCITY Compute takeoff speed using stall-margin formula.
            V_to = 1.2 * sqrt(2 * W0 / (rho * S * CL_max));
        end

        function L = L(V, CL, rho, S)
            %L Compute lift force from dynamic pressure and lift
            %   coefficient.
            L = (1/2) * rho * V^2 * S * CL;
        end

        function D = D(V, CD, rho, S)
            %D Compute drag force from dynamic pressure and drag 
            %   coefficient.
            D = (1/2) * rho * V^2 * S * CD;
        end

        function T_req = thrust_required(D, W, gamma)
            %THRUST Compute thrust required for a flight-path angle.
            %   Uses gamma in degrees.
            T_req = D + W * sind(gamma);
        end

        function x = x_distance(V, t, gamma)
            %X_DISTANCE Compute the horizontal distance for a segment in
            %   meters. Uses gamma in degrees.
            x = V * t * cosd(gamma);
        end

        function x_to = x_to(V_to, CL_max, CD_max, T_to, W, rho, S, g, mu_r)
            %X_TO Calculate the takeoff distance
            V_ref = 0.7 * V_to;
            q_ref = 0.5 * rho * V_ref^2;
            L_ref = q_ref * S * CL_max;
            D_ref = q_ref * S * CD_max;
            F_eff = T_to - (D_ref + mu_r*(W - L_ref));
            x_to = 1.44 * W^2 / (g * rho * S * CL_max * F_eff);
        end

        function t = t_takeoff(x_to, V_to)
            %T_TAKEOFF Compute the time for takeoff
            t = x_to / V_to;
        end

        function t = t_climb_descent(V, h, gamma)
            %T_CLIMB_DESCENT Compute the time it takes to traverse a climb or 
            %   descent segment with height change h. 
            %   Uses gamma in degrees.
            t = h / (V*sind(gamma));
        end

        function mf_rate = mass_flow_rate(T, SFC)
            %MASS_FLOW_RATE Calculate the mass flow rate from the 
            %   thrust and specific fuel consumption
            mf_rate = T * SFC;
        end

        function mf_total = mass_flow_total(mf_rate, time)
            %MASS_FLOW_TOTAL Calculate the total mass flow over time.
            mf_total = mf_rate * time;
        end
    end
end