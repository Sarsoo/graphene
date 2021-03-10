%% conductivity_calc_surface.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all; clear all; clc;

DISPLAY_HZ = true;

MIN_F = 0;
MAX_F = 15; % Hz
F_TOTAL = 50;

MAX_Y = 30; % carriers
Y_TOTAL = 50;

f_vals = logspace(MIN_F, MAX_F, F_TOTAL); % hz
f_vals = f_vals .* (2*pi); % rads-1

y_vals = logspace(0, MAX_Y, Y_TOTAL); % ev
%y_vals = -MAX_Y:2*MAX_Y/Y_TOTAL:MAX_Y; % ev
%y_vals = y_vals + 273.15;

cond = zeros(length(f_vals), length(y_vals));
for freq=1:length(f_vals)
    for y=1:length(y_vals)
        % omega (rads-1), fermi_level (J), temp (K), scatter_lifetime (s-1)
        cond(freq, y) = sheet_conductivity(f_vals(freq), fermi_from_carrier_density(y_vals(y)), 300, 5e-15);
    end
end

if DISPLAY_HZ % divide radians back to hertz
    f_vals = f_vals ./ (2*pi);
end

figure(1)
surf(f_vals, y_vals, transpose(real(cond)));
h = gca;
rotate3d on
grid;
colorbar;
set(h, 'xscale', 'log')
set(h, 'yscale', 'log')
title('2D Sheet Real Conductivity');
ylabel('Net Carrier Density');
zlabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end

figure(2)
surf(f_vals, y_vals, transpose(imag(cond)));
h = gca;
rotate3d on
grid;
colorbar;
set(h, 'xscale', 'log')
set(h, 'yscale', 'log')
title('2D Sheet Imaginary Conductivity');
ylabel('Net Carrier Density');
zlabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end

