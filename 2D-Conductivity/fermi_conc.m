%% fermi_conc.m
%%
%% present fermi levels for different carrier concentrations

close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    FLAGS & OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%

MIN_CONC = 0;
MAX_CONC = 20;
X_TOTAL = 1e2; % number of points to generate

DISP_EV = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     CALCULATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_vals = logspace(MIN_CONC, MAX_CONC, X_TOTAL); % hz

% CALCULATE SHEET CONDUCTIVITY
energy = zeros(1, length(x_vals));
for x=1:length(x_vals)
    temp = fermi_from_carrier_density(x_vals(x), ev_to_j(2.8)); % scatter_lifetime (s)
    if DISP_EV
        temp = j_to_ev(temp);
    end
    energy(1, x) = temp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       RENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INTRA
plot(x_vals, energy, 'LineWidth', 1.5);

title('Fermi level for differing carrier concentrations');

set(gca,'Xscale','log')
set(gca,'Yscale','log')
% axis tight

grid;
xlabel('Carrier Concentration (m^{-2})');
if DISP_EV
    ylabel('Fermi Energy (eV)');
else
    ylabel('Fermi Energy (J)');
end