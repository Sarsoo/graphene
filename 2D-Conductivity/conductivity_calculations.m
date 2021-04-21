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
% EXCITATION_TYPE = 'inter';
EXCITATION_TYPE = 'all';

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
                                    fermi_from_carrier_density(1.3e13*100*100, ev_to_j(3)),... % fermi_level (J)
                                    300,... % temp (K)
                                    1e-12); % scatter_lifetime (s)
end

if MULTIPLE_SERIES
    cond2 = zeros(length(x_vals), 2);
    for x=1:length(x_vals)
        cond2(x, :) = sheet_conductivity(x_vals(x),... % omega (rads-1)
                                        fermi_from_carrier_density(2.2e13*100*100, ev_to_j(3)),... % fermi_level (J)
                                        300,... % temp (K)
                                        1e-12); % scatter_lifetime (s)
    end
    
%     cond3 = zeros(length(x_vals), 2);
%     for x=1:length(x_vals)
%         cond3(x, :) = sheet_conductivity(x_vals(x),... % omega (rads-1)
%                                         fermi_from_carrier_density(1.3e13*10000, ev_to_j(3)),... % fermi_level (J)
%                                         300,... % temp (K)
%                                         1e-12); % scatter_lifetime (s)
%     end
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
RE_COLOUR2 = 'b-';
IM_COLOUR2 = 'b--';
MAG_COLOUR2 = 'b:';
RE_COLOUR3 = 'b';
IM_COLOUR3 = 'b--';
MAG_COLOUR3 = 'b:';
LW = 2;

figure(1);
hold on;
% INTRA
if strcmp(EXCITATION_TYPE, 'intra')
    plot(x_vals, real(cond(:, 1)), RE_COLOUR, 'LineWidth', LW);
    plot(x_vals, imag(cond(:, 1)), IM_COLOUR, 'LineWidth', LW);
    plot(x_vals, abs(cond(:, 1)), MAG_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, real(cond2(:, 1)), RE_COLOUR2, 'LineWidth', LW);
        plot(x_vals, imag(cond2(:, 1)), IM_COLOUR2, 'LineWidth', LW);
        plot(x_vals, abs(cond2(:, 1)), MAG_COLOUR2, 'LineWidth', LW);
        
%         plot(x_vals, real(cond3(:, 1)), RE_COLOUR3, 'LineWidth', LW);
%         plot(x_vals, imag(cond3(:, 1)), IM_COLOUR3, 'LineWidth', LW);
%         plot(x_vals, abs(cond3(:, 1)), MAG_COLOUR3, 'LineWidth', LW);
    end
    title('2D Intraband Sheet Conductivity');

% INTER
elseif strcmp(EXCITATION_TYPE, 'inter')
    plot(x_vals, real(cond(:, 2)), RE_COLOUR, 'LineWidth', LW);
    plot(x_vals, imag(cond(:, 2)), IM_COLOUR, 'LineWidth', LW);
    plot(x_vals, abs(cond(:, 2)), MAG_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, real(cond2(:, 2)), RE_COLOUR2, 'LineWidth', LW);
        plot(x_vals, imag(cond2(:, 2)), IM_COLOUR2, 'LineWidth', LW);
        plot(x_vals, abs(cond2(:, 2)), MAG_COLOUR2, 'LineWidth', LW);
        
%         plot(x_vals, real(cond3(:, 2)), RE_COLOUR3, 'LineWidth', LW);
%         plot(x_vals, imag(cond3(:, 2)), IM_COLOUR3, 'LineWidth', LW);
%         plot(x_vals, abs(cond3(:, 2)), MAG_COLOUR3, 'LineWidth', LW);
    end
    title('2D Interband Sheet Conductivity');
    
% COMPLEX
else
    plot(x_vals, real(sum(cond, 2)), RE_COLOUR, 'LineWidth', LW);
    plot(x_vals, imag(sum(cond, 2)), IM_COLOUR, 'LineWidth', LW);
    plot(x_vals, abs(sum(cond, 2)), MAG_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, real(sum(cond2, 2)), RE_COLOUR2, 'LineWidth', LW);
        plot(x_vals, imag(sum(cond2, 2)), IM_COLOUR2, 'LineWidth', LW);
        plot(x_vals, abs(sum(cond2, 2)), MAG_COLOUR2, 'LineWidth', LW);
        
%         plot(x_vals, real(sum(cond3, 2)), RE_COLOUR3, 'LineWidth', LW);
%         plot(x_vals, imag(sum(cond3, 2)), IM_COLOUR3, 'LineWidth', LW);
%         plot(x_vals, abs(sum(cond3, 2)), MAG_COLOUR3, 'LineWidth', LW);
    end
    title('2D Sheet Conductivity');
end

set(gca,'Xscale','log')
% set(gca,'Yscale','log')
axis tight

if MULTIPLE_SERIES
    legend('Re(TTF)', 'Im(TTF)', '|TTF|', 'Re(CoCp_2)', 'Im(CoCp_2)', '|CoCp_2|');
%     legend('Re(1x10^{8}m^{-2})', 'Im(1x10^{8}m^{-2})', '|1x10^{8}m^{-2}|', 'Re(1x10^{15}m^{-2})', 'Im(1x10^{15}m^{-2})', '|1x10^{15}m^{-2}|', 'Re(1.3x10^{17}m^{-2})', 'Im(1.3x10^{17}m^{-2})', '|1.3x10^{17}m^{-2}|');
else
    legend('Real', 'Imaginary');
end
grid;
ylabel('Conductivity (S)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end
