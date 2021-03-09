function fermi = fermi_from_carrier_density(carrier_density)

if carrier_density > 0
    sf = 1;
else
    sf = -1;
end

carrier_density = abs(carrier_density);

a = 0.246e-9; % lattice constant (m)
t = 2.8; % eV
hbar = 6.626e-34 / (2*pi); % Js

root_3_over_2 = sqrt(3) / 2;

fermi_velocity_eq = (root_3_over_2 * a * ev_to_j(t))^2;
fermi = sf * sqrt(carrier_density * pi * fermi_velocity_eq);

end

