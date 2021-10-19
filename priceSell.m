function price = priceSell(price, r)
    % price \in \mathbb{R}^{1\times n_p}
    pricetemp = 1 - (r - 1) / (r + factorial(r));
    price = price * pricetemp;
end
