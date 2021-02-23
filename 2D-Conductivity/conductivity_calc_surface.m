%% conductivity_calc_surface.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all; clear all; clc;

DISPLAY_HZ = true;
MAX_F = 1e12; % Hz
F_TOTAL = 1e3;
MAX_Y = 10; % ev
Y_TOTAL = 100;

f_vals = 1:MAX_F/F_TOTAL:MAX_F; % hz
f_vals = f_vals .* (2*pi); % rads-1

y_vals = 1:MAX_Y/Y_TOTAL:MAX_Y; % ev
%y_vals = y_vals + 273.15;

cond = zeros(length(f_vals), length(y_vals));
for freq=1:length(f_vals)
    for y=1:length(y_vals)
        % omega (rads-1), fermi_level (J), temp (K), scatter_lifetime (s-1)
        cond(freq, y) = sheet_conductivity(f_vals(freq), ev_to_j(y_vals(y)), 300, 5e-12);
    end
end

if DISPLAY_HZ % divide radians back to hertz
    f_vals = f_vals ./ (2*pi);
end

surf(f_vals, y_vals, transpose(abs(cond)));

h = gca;
rotate3d on
grid();
set(h, 'xscale', 'log')
title('2D Sheet Conductivity');
ylabel('Fermi Level (ev)');
zlabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end
