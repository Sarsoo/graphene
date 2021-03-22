%% conductivity_calc_surface.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    FLAGS & OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%

DISPLAY_HZ = true;

MIN_F = 0;
MAX_F = 15; % Hz
F_TOTAL = 50;

MAX_Y = 17; % carriers (m-2)
Y_TOTAL = 50;

%EXCITATION_TYPE = 'intra';
EXCITATION_TYPE = 'inter';
%EXCITATION_TYPE = 'all';

t = 2.8; % eV

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     CALCULATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_vals = logspace(MIN_F, MAX_F, F_TOTAL); % hz
f_vals = f_vals .* (2*pi); % rads-1

carrier_vals = logspace(0, MAX_Y, Y_TOTAL); % m-2
%carrier_vals = carrier_vals + 273.15;

% below turns turns carrier densities into Fermi energies
fermi_vals = zeros(1, length(carrier_vals));
for carr=1:length(carrier_vals)
    fermi_vals(carr) = fermi_from_carrier_density(carrier_vals(carr), ev_to_j(t));
end


% CALCULATE SHEET CONDUCTIVITY
cond = zeros(length(f_vals), % frequency
             length(fermi_vals), % fermi
             2); % intra/inter
for freq=1:length(f_vals)
    for y=1:length(fermi_vals)
        
        cond(freq, y, :) = sheet_conductivity(f_vals(freq), % omega (rads-1)
                                              fermi_vals(y), % fermi_level (J)
                                              300, % temp (K)
                                              5e-12); % scatter_lifetime (s-1)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       RENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DISPLAY_HZ % divide radians back to hertz
    f_vals = f_vals ./ (2*pi);
end

figure(1)
if EXCITATION_TYPE == 'intra'
    surf(f_vals, carrier_vals, transpose(real(cond(:, :, 1))));
elseif EXCITATION_TYPE == 'inter'
    surf(f_vals, carrier_vals, transpose(real(cond(:, :, 2))));
else
    surf(f_vals, carrier_vals, transpose(real(sum(cond, 3))));
end
h = gca;
rotate3d on
grid;
colorbar;
set(h, 'xscale', 'log')
set(h, 'yscale', 'log')
title('2D Sheet Real Conductivity');
ylabel('Net Carrier Density (m-2)');
zlabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end

figure(2)
if EXCITATION_TYPE == 'intra'
    surf(f_vals, carrier_vals, transpose(imag(cond(:, :, 1))));
elseif EXCITATION_TYPE == 'inter'
    surf(f_vals, carrier_vals, transpose(imag(cond(:, :, 2))));
else
    surf(f_vals, carrier_vals, transpose(imag(sum(cond, 3))));
end
surf(f_vals, carrier_vals, transpose(imag(sum(cond, 3))));
h = gca;
rotate3d on
grid;
colorbar;
set(h, 'xscale', 'log')
set(h, 'yscale', 'log')
title('2D Sheet Imaginary Conductivity');
ylabel('Net Carrier Density (m-2)');
zlabel('Conductivity (S/m)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end

