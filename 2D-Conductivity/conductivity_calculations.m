%% conductivity_calculations.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    FLAGS & OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%

DISPLAY_HZ = true;
MIN_F = 9;
MAX_F = 15;
F_TOTAL = 1e2;

%EXCITATION_TYPE = 'intra';
EXCITATION_TYPE = 'inter';
%EXCITATION_TYPE = 'all';

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     CALCULATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_vals = logspace(MIN_F, MAX_F, F_TOTAL); % hz
x_vals = x_vals .* (2*pi); % rads-1

% CALCULATE SHEET CONDUCTIVITY
cond = zeros(length(x_vals), 2);
for x=1:length(x_vals)
    cond(x, :) = sheet_conductivity(x_vals(x), % omega (rads-1)
                                    fermi_from_carrier_density(2.2e17, ev_to_j(2.8)), % fermi_level (J)
                                    300, % temp (K)
                                    0.135e-12); % scatter_lifetime (s-1)
end

if DISPLAY_HZ % divide radians back to hertz
    x_vals = x_vals ./ (2*pi);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       RENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
hold on;
%plot(x_vals, real(cond));
if EXCITATION_TYPE == 'intra'
    semilogx(x_vals, real(cond(:, 1)));
    semilogx(x_vals, imag(cond(:, 1)));
elseif EXCITATION_TYPE == 'inter'
    semilogx(x_vals, real(cond(:, 2)));
    semilogx(x_vals, imag(cond(:, 2)));
else
    semilogx(x_vals, real(sum(cond, 2)));
    semilogx(x_vals, imag(sum(cond, 2)));
end

legend('Real', 'Imaginary');
grid;
title('2D Sheet Conductivity');
ylabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end
