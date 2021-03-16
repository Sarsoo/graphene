function fermi = fermi_velocity (energy_scale) % J

a = 0.246e-9; % lattice constant (m)
hbar = 6.626e-34 / (2*pi); % Js

fermi = (sqrt(3)/2) * a * energy_scale / hbar;

end
% m/s