%% conductivity_calc_surface.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    FLAGS & OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%

DISPLAY_HZ = true; % convert rads back to Hz for presenting

MIN_F = 9;
MAX_F = 15; % Hz
F_TOTAL = 50; % number of points to generate

MAX_Y = 18; % carriers (m-2)
Y_TOTAL = 50; % number of points to generate

% EXCITATION_TYPE = 'intra';
% EXCITATION_TYPE = 'inter';
EXCITATION_TYPE = 'all';

t = 2.8; % eV, energy scale for Fermi velocity

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     CALCULATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_vals = logspace(MIN_F, MAX_F, F_TOTAL); % hz
f_vals = f_vals .* (2*pi); % rads-1

% Carrier Density
%%%%%%%
carrier_vals = logspace(0, MAX_Y, Y_TOTAL); % m-2

% below turns turns carrier densities into Fermi energies
fermi_vals = zeros(1, length(carrier_vals));
for carr=1:length(carrier_vals)
    fermi_vals(carr) = fermi_from_carrier_density(carrier_vals(carr), ev_to_j(t));
end

% CALCULATE SHEET CONDUCTIVITY
cond = zeros(length(f_vals),... % frequency
             length(fermi_vals),... % fermi
             2); % intra/inter
for freq=1:length(f_vals)
    for y=1:length(fermi_vals)
        
        cond(freq, y, :) = sheet_conductivity(f_vals(freq),... % omega (rads-1)
                                              fermi_vals(y),... % fermi_level (J)
                                              300,... % temp (K)
                                              5e-12); % scatter_lifetime (s)
    end
end

% Temperature
%%%%%%%
% temp_vals = linspace(0, 2230, Y_TOTAL); % K
% 
% CALCULATE SHEET CONDUCTIVITY
% cond = zeros(length(f_vals),... % frequency
%              length(temp_vals),... % fermi
%              2); % intra/inter
% for freq=1:length(f_vals)
%     for y=1:length(temp_vals)
%         
%         cond(freq, y, :) = sheet_conductivity(f_vals(freq),... % omega (rads-1)
%                                               fermi_from_carrier_density(1.3e13*10000, ev_to_j(t)),... % fermi_level (J)
%                                               temp_vals(y),... % temp (K)
%                                               5e-12); % scatter_lifetime (s)
%     end
% end

% Scatter Lifetime
%%%%%%%
% scatt_vals = logspace(-11, -14, Y_TOTAL); % s-1
% 
% % CALCULATE SHEET CONDUCTIVITY
% cond = zeros(length(f_vals),... % frequency
%              length(scatt_vals),... % fermi
%              2); % intra/inter
% for freq=1:length(f_vals)
%     for y=1:length(scatt_vals)
%         
%         cond(freq, y, :) = sheet_conductivity(f_vals(freq),... % omega (rads-1)
%                                               fermi_from_carrier_density(1.3e13*10000, ev_to_j(t)),... % fermi_level (J), ttf = 1.3e13*10000, cocp2 = 2.2e13*10000
%                                               300,... % temp (K)
%                                               scatt_vals(y)); % scatter_lifetime (s)
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       RENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DISPLAY_HZ % divide radians back to hertz
    f_vals = f_vals ./ (2*pi);
end

y_vals = carrier_vals;

% cond = sign(cond).*log10(abs(cond));

figure(1)
if strcmp(EXCITATION_TYPE, 'intra')
    surf(f_vals, y_vals, transpose(real(cond(:, :, 1))));
    title('2D Real Intraband Sheet Conductivity');
elseif strcmp(EXCITATION_TYPE, 'inter')
    surf(f_vals, y_vals, transpose(real(cond(:, :, 2))));
    title('2D Real Interband Sheet Conductivity');
else
    surf(f_vals, y_vals, transpose(real(sum(cond, 3))));
    title('2D Real Sheet Conductivity');
end

rotate3d on
grid;
colorbar;
axis tight;
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
% set(gca, 'zscale', 'log')

set(gca, 'ColorScale', 'log')

ylabel('Net Carrier Density (m^{-2})');
% ylabel('Temperature (K)');
% ylabel('Scatter Lifetime (s)');

zlabel('Conductivity (S)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end

figure(2)
if strcmp(EXCITATION_TYPE, 'intra')
    surf(f_vals, y_vals, transpose(imag(cond(:, :, 1))));
    title('2D Imaginary Intraband Sheet Conductivity');
elseif strcmp(EXCITATION_TYPE, 'inter')
    surf(f_vals, y_vals, transpose(imag(cond(:, :, 2))));
    title('2D Imaginary Interband Sheet Conductivity');
else
    surf(f_vals, y_vals, transpose(imag(sum(cond, 3))));
    title('2D Imaginary Sheet Conductivity');
end

rotate3d on
grid;
colorbar;
axis tight;
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
% set(gca, 'zscale', 'log')

set(gca, 'ColorScale', 'log')

ylabel('Net Carrier Density (m^{-2})');
% ylabel('Temperature (K)');
% ylabel('Scatter Lifetime (s)');

zlabel('Conductivity (S)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end

