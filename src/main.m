clc
clear

path.clean = '..\data\outputs\clean.pol';
path.iced_takeoff = '..\data\outputs\takeoff.pol';
p = params();

fuel_perc = 0.17;

clean_takeoff = takeoff(path.clean,'m_fuel_perc', fuel_perc)

iced_takeoff = takeoff(path.iced_takeoff,'m_fuel_perc', fuel_perc)

fuel_frac = linspace(0.1, 1.0, 50);

% for i = 1:length(fuel_frac)
%     clean = takeoff(path.clean, 'm_fuel_perc', fuel_frac(i));
%     iced_takeoff = takeoff(path.iced_takeoff, 'm_fuel_perc', fuel_frac(i));
%     if clean.x_to <= p.x_takeoff_max
%         feasible(i,1) = clean.x_to;
%     else
%         feasible(i,1) = -1;
%     end
%     if iced_takeoff.x_to <= p.x_takeoff_max
%         feasible(i,2) = iced_takeoff.x_to;
%     else
%         feasible(i,2) = -1;
%     end
% end

p.x_takeoff_max 

p.m_fuel_max
p.m_fuel_max * fuel_perc

