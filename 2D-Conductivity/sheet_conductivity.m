function conductivity = sheet_conductivity(omega, fermi_level, temp, scatter_lifetime)
%SHEET_CONDUCTIVITY Calculate 2D sheet conductivity

%% CONSTANTS
e = 1.602e-19; % coulombs
kb = 1.380e-23; % J/K
hbar = 6.626e-34 / (2*pi); % Js

%% TERM 1 - INTRABRAND
term1_coeff = (2i*(e^2)*kb*temp) ...
                    / ...
                (pi*hbar^2*(omega + (1i/scatter_lifetime)));
term1 = log(2*cosh(fermi_level ...
                    / ...
                (2*kb*temp)));

intraband = term1_coeff*term1;
                
%% TERM 2 - INTERBAND
term2_coeff = (e^2) ...
                / ...
            (4*hbar);

term_2_term_1 = 1/2;
term_2_term_2 = (1/pi) * ...
            atan((hbar*omega - 2*fermi_level) ...
                    / ...
                (2*kb*temp));

term_2_term_3 = (1i/(2*pi)) * ...
            log((hbar*omega + 2*fermi_level)^2 ...
                    / ...
                ((hbar*omega - 2*fermi_level)^2 + 4*((kb*temp)^2)));

interband = term2_coeff*(term_2_term_1 + term_2_term_2 - term_2_term_3);

%% OUTPUT
conductivity = [intraband interband]; % return separately for display or summing

end

