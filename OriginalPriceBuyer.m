function Price = OriginalPriceBuyer(Power, PriceGrid)
    sig = 1 / (1 + exp(-Power / 1000));
    para = abs(2 * sig - 1);
    Price = (1 - para) * PriceGrid;
end
