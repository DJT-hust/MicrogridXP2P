function price = priceBuy(price, r)
    pricetemp = 1 + (r - 1) / (r + factorial(r));
    price = price * pricetemp;
end
