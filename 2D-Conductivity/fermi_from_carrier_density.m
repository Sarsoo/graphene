function fermi = fermi_from_carrier_density(carrier_density, energy_scale), % cm-2, J

if carrier_density > 0
    sf = 1;
else
    sf = -1;
end

hbar = 6.626e-34 / (2*pi); % Js

carrier_density = abs(carrier_density);

fermi = sqrt(carrier_density * pi * ( hbar * fermi_velocity(energy_scale) )^2 );
fermi = sf * fermi;

end

