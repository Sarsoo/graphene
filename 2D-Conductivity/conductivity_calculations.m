%% conductivity_calculations.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all;clear all; clc;

DISPLAY_HZ = true;
MIN_F = 9;
MAX_F = 15;
F_TOTAL = 1e2;

x_vals = logspace(MIN_F, MAX_F, F_TOTAL); % hz
x_vals = x_vals .* (2*pi); % rads-1

cond = [];
for x=x_vals
    % omega (rads-1), fermi_level (J), temp (K), scatter_lifetime (s-1)
    cond = [cond sheet_conductivity(x, fermi_from_carrier_density(7e7, ev_to_j(2.8)), 3000, 5e-12)];
end

if DISPLAY_HZ % divide radians back to hertz
    x_vals = x_vals ./ (2*pi);
end

figure(1);
hold on;
%plot(x_vals, real(cond));
semilogx(x_vals, real(cond));
semilogx(x_vals, imag(cond));

legend('Real', 'Imaginary');
grid;
title('2D Sheet Conductivity');
ylabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end
