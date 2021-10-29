function PFact = WindPower(WindVelocity)
    n = size(WindVelocity, 2);
    PFact = zeros(1, n);
    % vCi = 0.5;
    % vRa = 2.5;
    % vCo = 3.5;
    % Pra = 5;
    % a = (Pra * vCi^3) / (vRa^3 - vCi^3);
    % b = (Pra) / (vRa^3 - vCi^3);
    a = 2 * 4^3 / (4^3 - 12.5^3);
    b = 2 / (12.5^3 - 4^3);

    for i = 1:n

        if WindVelocity(i) >= 0 && WindVelocity(i) <= 4
            PFact(i) = 0;
        elseif WindVelocity(i) <= 12.5
            PFact(i) = a + b * WindVelocity(i)^3;
        elseif WindVelocity(i) <= 20
            PFact(i) = 2;
        else
            PFact(i) = 0;
        end

    end
