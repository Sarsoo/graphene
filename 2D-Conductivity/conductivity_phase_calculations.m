%% conductivity_phase_calculations.m
%%
%% calculate and present 2D sheet conductivty phase for graphene

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
                                    fermi_from_carrier_density(1.3e17, ev_to_j(3)),... % fermi_level (J)
                                    300,... % temp (K)
                                    1e-12); % scatter_lifetime (s)
end

if MULTIPLE_SERIES
    cond2 = zeros(length(x_vals), 2);
    for x=1:length(x_vals)
        cond2(x, :) = sheet_conductivity(x_vals(x),... % omega (rads-1)
                                        fermi_from_carrier_density(2.2e17, ev_to_j(3)),... % fermi_level (J)
                                        300,... % temp (K)
                                        1e-12); % scatter_lifetime (s)
    end
    
%     cond3 = zeros(length(x_vals), 2);
%     for x=1:length(x_vals)
%         cond3(x, :) = sheet_conductivity(x_vals(x),... % omega (rads-1)
%                                         fermi_from_carrier_density(1.3e17, ev_to_j(3)),... % fermi_level (J)
%                                         300,... % temp (K)
%                                         1e-13); % scatter_lifetime (s)
%     end
end

if DISPLAY_HZ % divide radians back to hertz
    x_vals = x_vals ./ (2*pi);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       RENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%

RE_COLOUR = 'r';
RE_COLOUR2 = 'g';
RE_COLOUR3 = 'b';
LW = 2;

figure(1);
hold on;
% INTRA
if strcmp(EXCITATION_TYPE, 'intra')
    plot(x_vals, angle(cond(:, 1)) .* (180/pi), RE_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, angle(cond2(:, 1)) .* (180/pi), RE_COLOUR2, 'LineWidth', LW);
        
%         plot(x_vals, angle(cond3(:, 1)) .* (180/pi), RE_COLOUR3, 'LineWidth', LW);
    end
    title('2D Intraband Sheet Conductivity Phase');

% INTER
elseif strcmp(EXCITATION_TYPE, 'inter')
    plot(x_vals, angle(cond(:, 2)) .* (180/pi), RE_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, angle(cond2(:, 2)) .* (180/pi), RE_COLOUR2, 'LineWidth', LW);
        
%         plot(x_vals, angle(cond3(:, 2)) .* (180/pi), RE_COLOUR3, 'LineWidth', LW);
    end
    title('2D Interband Sheet Conductivity Phase');
    
% COMPLEX
else
    plot(x_vals, angle(sum(cond, 2)) .* (180/pi), RE_COLOUR, 'LineWidth', LW);
    
    if MULTIPLE_SERIES
        plot(x_vals, angle(sum(cond2, 2)) .* (180/pi), RE_COLOUR2, 'LineWidth', LW);
        
%         plot(x_vals, angle(sum(cond3, 2)) .* (180/pi), RE_COLOUR3, 'LineWidth', LW);
    end
    title('2D Sheet Conductivity Phase');
end

set(gca,'Xscale','log')
% set(gca,'Yscale','log')
axis tight
ylim([-90 90])

if MULTIPLE_SERIES
    legend('TTF \phi(\sigma)', 'CoCp_2 \phi(\sigma)');
%     legend('1x10^8m^{-2} \phi(\sigma)', '1x10^{15}m^{-2} \phi(\sigma)', '1.3x10^{17}m^{-2} \phi(\sigma)');
%     legend('10K \phi(\sigma)', '300K \phi(\sigma)', '2230K \phi(\sigma)');
%     legend('5x10^{-12} s \phi(\sigma)', '1x10^{-12} s \phi(\sigma)', '1x10^{-13} s \phi(\sigma)');
else
    legend('\phi');
end
grid;
ylabel('Conductivity Phase (Degrees)');
if DISPLAY_HZ
    xlabel('Frequency (Hz)');
else
    xlabel('Frequency (rads-1)');
end
