clear
clc

segments = ["Takeoff"; "Climb"; "Cruise"; "Descent"; "Landing"];

% Clean data
CL_clean = [0.80684; 0.8013; 0.31079; 0.5154 ; 0.6802];
CD_clean = [0.055013; 0.0546; 0.012710; 0.02539; 0.0162];
mf_clean = [332.67; 6812.7; 12403.974; 1.1211; 51.32];

tbl_clean = make_flight_table(segments, CL_clean, CD_clean, mf_clean);

% Iced data
CL_iced = [0.82217; 0.6438; 0.28294; 0.2249; 0.4057];
CD_iced = [0.06567; 0.0729; 0.018174; 0.0312; 0.0091];
mf_iced = [338.82; 10454; 18698.711; 247.6; 37.54];

tbl_iced = make_flight_table(segments, CL_iced, CD_iced, mf_iced);

disp(tbl_clean)
disp(tbl_iced)

plot_comparison(tbl_clean, tbl_iced)

function tbl = make_flight_table(segments, CL, CD, mf_total)
    LD = CL ./ CD;

    % Avoid Inf/NaN for missing rows
    LD(CD == 0) = NaN;

    tbl = table(segments, CL, CD, LD, mf_total, ...
        'VariableNames', ["segment", "CL", "CD", "LD", "mf_total"]);
end

function plot_comparison(tbl_clean, tbl_iced, out_dir)
    arguments
        tbl_clean table
        tbl_iced table
        out_dir string = "..\figures"
    end

    metrics = {
        "CL",       "Lift_Coefficient_CL", "Lift Coefficient C_L";
        "CD",       "Drag_Coefficient_CD", "Drag Coefficient C_D";
        "LD",       "Lift_to_Drag",        "Lift-to-Drag Ratio L/D";
        "mf_total", "Fuel_Consumed",       "Fuel Consumed [kg]"
    };

    segments = categorical(tbl_clean.segment);
    segments = reordercats(segments, tbl_clean.segment);

    for k = 1:size(metrics, 1)
        varname = metrics{k, 1};
        fname   = metrics{k, 2};
        label   = metrics{k, 3};

        Y = [tbl_clean.(varname), tbl_iced.(varname)];

        fig = figure;
        bar(segments, Y)
        grid on

        xlabel("Flight Segment")
        ylabel(label)
        title(label + ": Clean vs Iced")
        legend("Clean", "Iced", "Location", "best")

        exportgraphics(fig, fullfile(out_dir, fname + ".png"), "Resolution", 300)
        savefig(fig, fullfile(out_dir, fname + ".fig"))
    end
end