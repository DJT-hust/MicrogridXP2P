clear all
close all
clc

for index = 1:5
    buyer(index).P = 10 * rand() + 5;
    buyer(index).Ptemp = buyer(index).P;
    buyer(index).name = ['MGBUY' int2str(index)];
    buyer(index).flag = 1;
    buyer(index).price = OriginalPriceBuyer(buyer(index).P*100, 0.5);
end

for index = 1:7
    seller(index).P = 10 * rand() + 5;
    seller(index).Ptemp = seller(index).P;
    seller(index).name = ['MGSELL' int2str(index)];
    seller(index).flag = 1;
    seller(index).price = OriginalPriceSeller(seller(index).P*100, 0.5);
end

TableSeller = struct2table(seller); % convert the struct array to a table
sortedTableSeller = sortrows(TableSeller, 'price'); % sort the table by 'DOB'
seller = table2struct(sortedTableSeller); % change it back to struct array if necessary

TableBuyer = struct2table(buyer); % convert the struct array to a table
sortedTableBuyer = sortrows(TableBuyer, 'price'); % sort the table by 'DOB'
buyer = table2struct(sortedTableBuyer); % change it back to struct array if necessary

[pair, NoDealSeller, NoDealBuyer] = DealBuySell(seller, buyer);
