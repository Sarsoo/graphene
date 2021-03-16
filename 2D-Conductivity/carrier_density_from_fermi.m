function carrier_density = carrier_density_from_fermi(fermi, energy_scale) % J, J

if fermi > 0
    sf = 1;
else
    sf = -1;
end

hbar = 6.626e-34 / (2*pi); % Js

carrier_density = fermi^2 ... 
                    / ...
             (pi * ( hbar * fermi_velocity(energy_scale) )^2);
carrier_density = sf * carrier_density;
end

