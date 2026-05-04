clc
clear

path.clean = '..\data\polars\clean.pol';
path.iced_takeoff = '..\data\polars\takeoff.pol';
path.outputs = '..\data\outputs\';

fuel_fracs = linspace(0.05, 1.00, 96);
run1 = run_takeoff_sweep(path, fuel_fracs, "course");
disp(run1.best_clean_to)
disp(run1.best_iced_to)

fuel_fracs = 0.14:0.001:0.17;
run2 = run_takeoff_sweep(path, fuel_fracs, "fine");
disp(run2.best_clean_to)
disp(run2.best_iced_to)

function out = run_takeoff_sweep(path, fuel_fracs, tag)
    arguments
        path
        fuel_fracs double
        tag string = "sweep"
    end
    out.tbl_clean_to = takeoff_sweep(path.clean, fuel_fracs);
    out.tbl_iced_to = takeoff_sweep(path.iced_takeoff, fuel_fracs);
    
    writetable(out.tbl_clean_to, path.outputs + "takeoff_clean_" + tag + ".csv");
    writetable(out.tbl_iced_to, path.outputs + "takeoff_iced_" + tag + ".csv");

    out.best_clean_to = best_valid(out.tbl_clean_to);
    out.best_iced_to = best_valid(out.tbl_iced_to);
end

function best = best_valid(tbl)
    ok = tbl(tbl.runway_ok, :);

    if isempty(ok)
        best = table();
    else
        best = ok(1, :); % highest fuel fraction if table is sorted descending
    end
end