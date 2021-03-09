function carrier_density = carrier_density_from_fermi(fermi)

if fermi > 0
    sf = 1;
else
    sf = -1;
end

a = 0.246e-9; % lattice constant (m)
t = 2.8; % eV
hbar = 6.626e-34 / (2*pi); % Js

root_3_over_2 = sqrt(3) / 2;

carrier_density = fermi^2 / (pi * (root_3_over_2 * a * ev_to_j(t))^2);
carrier_density = sf * carrier_density;
end

