%% conductivity_calculations.m
%%
%% calculate and present 2D sheet conductivty for graphene

close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    FLAGS & OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%

DISPLAY_HZ = true; % convert rads back to Hz for presenting

MIN_F = 9;
MAX_F = 15;
F_TOTAL = 1e2; % number of points to generate

% EXCITATION_TYPE = 'intra';
EXCITATION_TYPE = 'inter';
% EXCITATION_TYPE = 'all';

MULTIPLE_SERIES = true; % for comparing two dopants

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     CALCULATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_vals = logspace(MIN_F, MAX_F, F_TOTAL); % hz
x_vals = x_vals .* (2*pi); % rads-1

% CALCULATE SHEET CONDUCTIVITY
cond = zeros(length(x_vals), 2);
for x=1:length(x_vals)
    cond(x, :) = sheet_conductivity(x_vals(x),... % omega (rads-1)
                                    fermi_from_carrier_density(1.3e17, ev_to_j(3)),... % fermi_level (J)
                                    10,... % temp (K)
                                    1e-12); % scatter_lifetime (s)
end

if MULTIPLE_SERIES
    cond2 = zeros(length(x_vals), 2);
    for x=1:length(x_vals)
        cond2(x, :) = sheet_conductivity(x_vals(x),... % omega (rads-1)
                                        fermi_from_carrier_density(1.3e17, ev_to_j(3)),... % fermi_level (J)
                                        300,... % temp (K)
                                        1e-12); % scatter_lifetime (s)
    end
    
    cond3 = zeros(length(x_vals), 2);
    for x=1:length(x_vals)
        cond3(x, :) = sheet_conductivity(x_vals(x),... % omega (rads-1)
                                        fermi_from_carrier_density(1.3e17, ev_to_j(3)),... % fermi_level (J)
                                        2230,... % temp (K)
                                        1e-12); % scatter_lifetime (s)
    end
end

if DISPLAY_HZ % divide radians back to hertz
    x_vals = x_vals ./ (2*pi);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       RENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%

RE_COLOUR = 'r-';
IM_COLOUR = 'r--';
MAG_COLOUR = 'r:';
RE_COLOUR2 = 'g-';
IM_COLOUR2 = 'g--';
MAG_COLOUR2 = 'g:';
RE_COLOUR3 = 'b';
IM_COLOUR3 = 'b--';
MAG_COLOUR3 = 'b:';
LW = 2;

figure(1);
hold on;
% INTRA
if strcmp(EXCITATION_TYPE, 'intra')
    cond = cond * 1e3;
    cond2 = cond2 * 1e3;
    cond3 = cond3 * 1e3;
    ylabel('Conductivity (mS)');
    
    plot(x_vals, real(cond(:, 1)), RE_COLOUR, 'LineWidth', LW);
    plot(x_vals, imag(cond(:, 1)), IM_COLOUR, 'LineWidth', LW);
    plot(x_vals, abs(cond(:, 1)), MAG_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, real(cond2(:, 1)), RE_COLOUR2, 'LineWidth', LW);
        plot(x_vals, imag(cond2(:, 1)), IM_COLOUR2, 'LineWidth', LW);
        plot(x_vals, abs(cond2(:, 1)), MAG_COLOUR2, 'LineWidth', LW);
        
        plot(x_vals, real(cond3(:, 1)), RE_COLOUR3, 'LineWidth', LW);
        plot(x_vals, imag(cond3(:, 1)), IM_COLOUR3, 'LineWidth', LW);
        plot(x_vals, abs(cond3(:, 1)), MAG_COLOUR3, 'LineWidth', LW);
    end
    title('2D Intraband Sheet Conductivity');

% INTER
elseif strcmp(EXCITATION_TYPE, 'inter')
    cond = cond * 1e6;
    cond2 = cond2 * 1e6;
    cond3 = cond3 * 1e6;
    ylabel('Conductivity (\muS)');
    
    plot(x_vals, real(cond(:, 2)), RE_COLOUR, 'LineWidth', LW);
    plot(x_vals, imag(cond(:, 2)), IM_COLOUR, 'LineWidth', LW);
    plot(x_vals, abs(cond(:, 2)), MAG_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, real(cond2(:, 2)), RE_COLOUR2, 'LineWidth', LW);
        plot(x_vals, imag(cond2(:, 2)), IM_COLOUR2, 'LineWidth', LW);
        plot(x_vals, abs(cond2(:, 2)), MAG_COLOUR2, 'LineWidth', LW);
        
        plot(x_vals, real(cond3(:, 2)), RE_COLOUR3, 'LineWidth', LW);
        plot(x_vals, imag(cond3(:, 2)), IM_COLOUR3, 'LineWidth', LW);
        plot(x_vals, abs(cond3(:, 2)), MAG_COLOUR3, 'LineWidth', LW);
    end
    title('2D Interband Sheet Conductivity');
    
% COMPLEX
else
    cond = cond * 1e3;
    cond2 = cond2 * 1e3;
    cond3 = cond3 * 1e3;
    ylabel('Conductivity (mS)');
    
    plot(x_vals, real(sum(cond, 2)), RE_COLOUR, 'LineWidth', LW);
    plot(x_vals, imag(sum(cond, 2)), IM_COLOUR, 'LineWidth', LW);
    plot(x_vals, abs(sum(cond, 2)), MAG_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, real(sum(cond2, 2)), RE_COLOUR2, 'LineWidth', LW);
        plot(x_vals, imag(sum(cond2, 2)), IM_COLOUR2, 'LineWidth', LW);
        plot(x_vals, abs(sum(cond2, 2)), MAG_COLOUR2, 'LineWidth', LW);
        
        plot(x_vals, real(sum(cond3, 2)), RE_COLOUR3, 'LineWidth', LW);
        plot(x_vals, imag(sum(cond3, 2)), IM_COLOUR3, 'LineWidth', LW);
        plot(x_vals, abs(sum(cond3, 2)), MAG_COLOUR3, 'LineWidth', LW);
    end
    title('2D Sheet Conductivity');
end

set(gca,'Xscale','log')
% set(gca,'Yscale','log')
axis tight
% ylim([-inf 225])

if MULTIPLE_SERIES
%     legend('TTF Re(\sigma)', 'TTF Im(\sigma)', 'TTF |\sigma|', 'CoCp_2 Re(\sigma)', 'CoCp_2 Im(\sigma)', 'CoCp_2 |\sigma|');
    legend('1x10^{8}m^{-2} Re(\sigma)', '1x10^{8}m^{-2} Im(\sigma)', '1x10^{8}m^{-2} |\sigma|', '1x10^{15}m^{-2} Re(\sigma)', '1x10^{15}m^{-2} Im(\sigma)', '1x10^{15}m^{-2} |\sigma|', '1.3x10^{17}m^{-2} Re(\sigma)', '1.3x10^{17}m^{-2} Im(\sigma)', '1.3x10^{17}m^{-2} |\sigma|');
%     legend('10K Re(\sigma)', '10K Im(\sigma)', '10K |\sigma|', '300K Re(\sigma)', '300K Im(\sigma)', '300K |\sigma|', '2230K Re(\sigma)', '2230K Im(\sigma)', '2230K |\sigma|');
%     legend('5x10^{-12} s Re(\sigma)', '5x10^{-12} s Im(\sigma)', '5x10^{-12} s |\sigma|', '1x10^{-12} s Re(\sigma)', '1x10^{-12} s Im(\sigma)', '1x10^{-12} s |\sigma|', '1x10^{-13} s Re(\sigma)', '1x10^{-13} s Im(\sigma)', '1x10^{-13} s |\sigma|');
else
    legend('Real', 'Imaginary');
end
grid;

if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end
