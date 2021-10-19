clear
clc

price=[20];
for r = 2:30
    pricetemp=1-(r-1)/(r+factorial(r));
    price=[price,pricetemp*price(r-1)];
end
r=1:30;
figure
box on
grid on
plot(r,price,'.');