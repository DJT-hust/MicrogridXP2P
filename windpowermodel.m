function wind_power = windpowermodel(wind_speed) % 已知风速计算风功率！ 正确的！MW
    wind_power = zeros(1, 1);
    para = 2 * 4^3 / (4^3 - 12.5^3);
    parb = 2 / (12.5^3 - 4^3);
    temp_power = para + parb .* wind_speed.^3;
    wind_power(wind_speed > 4 & wind_speed <= 12.5) = temp_power(wind_speed > 4 & wind_speed <= 12.5);
    temp_power = 2 .* ones(1, 5);
    wind_power(wind_speed > 12.5 & wind_speed <= 20) = temp_power(wind_speed > 12.5 & wind_speed <= 20);
end
