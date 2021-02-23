%% conductivity_calculations.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all; clear all; clc;

DISPLAY_HZ = true;
MAX_F = 1e12;
F_TOTAL = 1e4;

x_vals = 1:MAX_F/F_TOTAL:MAX_F; % hz
x_vals = x_vals .* (2*pi); % rads-1

% omega (rads-1), fermi_level (J), temp (K), scatter_lifetime (s-1)
cond = arrayfun(@(x) sheet_conductivity(x, ev_to_j(3), 300, 5e-12), x_vals);

if DISPLAY_HZ % divide radians back to hertz
    x_vals = x_vals ./ (2*pi);
end

%plot(x_vals, cond);
semilogx(x_vals, cond);

grid();
title('2D Sheet Conductivity');
ylabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end
