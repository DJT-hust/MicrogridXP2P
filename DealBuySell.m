function DealResults = DealBuySell(seller, buyer)
    %% -----------------交易策略---------------------------
    % 基本思想：高价匹配高价，低价匹配低价
    % input：seller：P富余的功率；Ptemp

    NIR = 10; %迭代次数
    Nc = size(buyer); %消费者数目
    Np = size(seller); %卖出者数目
    pair = {};
    IrPair = 1;

    for r = 1:NIR
        sell = 1;
        buy = 1;

        for index = 1:Np
            seller(index).Ptemp = seller(index).P * seller(index).flag;
        end

        for index = 1:Nc
            buyer(index).Ptemp = buyer(index).P * buyer(index).flag;
        end

        while (sell < Np & buy < Nc)

            if (buyer(buy).price >= seller(sell).price) & (buyer(buy).flag == 1 & seller(sell).falg == 1)

                if (buyer(buy).Ptemp > seller(sell).Ptemp)
                    buyer(buy).P = buyer(buy).P - seller(sell).P;
                    buyer(buy).Ptemp = buyer(buy).P;
                    % pair = [pair, [buy, sell, seller(sell).P, seller(sell).price]];
                    pair(IrPair) = [buy, sell, seller(sell).P, seller(sell).price];
                    IrPair = IrPair + 1;
                    seller(sell).P = 0;
                    seller(sell).falg = 0;
                    seller(sell).Ptemp = 0;
                    sell = sell + 1;
                elseif (buyer(buy).Ptemp < seller(sell).Ptemp)
                    seller(sell).P = seller(sell).P - buyer(buy).P
                    seller(sell).Ptemp = seller(sell).P;
                    % pair = [pair, [buy, sell, buyer(buy).P, seller(sell).price]];
                    pair(IrPair) = [buy, sell, seller(sell).P, seller(sell).price];
                    IrPair = IrPair + 1;
                    buyer(buy).P = 0;
                    buyer(buy).falg = 0;
                    buyer(buy).Ptemp = 0;
                    buy = buy + 1;
                elseif (buyer(buy).Ptemp = seller(sell).Ptemp)
                    % pair = [pair, [buy, sell, buyer(buy).P, seller(sell).price]];
                    pair(IrPair) = [buy, sell, seller(sell).P, seller(sell).price];
                    IrPair = IrPair + 1;
                    seller(sell).P = 0;
                    seller(sell).falg = 0;
                    seller(sell).Ptemp = 0;
                    buyer(buy).P = 0;
                    buyer(buy).falg = 0;
                    buyer(buy).Ptemp = 0;
                    sell = sell + 1;
                    buy = buy + 1;
                end

            elseif (buyer(buy).price < seller(sell).price) & (buyer(buy).flag == 1 & seller(sell).falg == 1)

                if (buyer(buy).Ptemp > seller(sell).Ptemp)
                    buyer(buy).Ptemp = buyer(buy).P - seller(sell).P;
                    seller(sell).Ptemp = 0;
                    sell = sell + 1;
                elseif (buyer(buy).Ptemp < seller(sell).Ptemp)
                    seller(sell).Ptemp = seller(sell).P - buyer(buy).P;
                    buyer(buy).Ptemp = 0;
                    buy = buy + 1;
                elseif (buyer(buy).Ptemp = seller(sell).Ptemp)
                    seller(sell).Ptemp = 0;
                    buyer(buy).Ptemp = 0;
                    sell = sell + 1;
                    buy = buy + 1;
                end

            elseif seller(sell).flag * buyer(buy).flag == 0
                sell = sell + (1 - seller(sell).flag);
                buy = buy + (1 - buyer(buy).flag);
            end

        end

        FLGA = 0;

        for index = 1:Np
            FLAG = FLAG + seller(index).flag;
        end

        for index = 1:Nc
            FLAG = FLAG + buyer(index).flag;
        end

        if FLAG == 0
            break;
        end

        for index = 1:Np
            seller(index).price = priceSell(seller(index).price, r);
        end

        for index = 1:Nc
            buyer(index).price = priceBuy(buyer(index).price, r);
        end

    end

    NoDealSeller = {};
    NoDealBuyer = {};
    IrNoDealSeller = 1;
    IrNoDealBuyer = 1;

    for index = 1:Np

        if seller(index).flag == 1
            % NoDealSeller = [NoDealSeller, [index, seller(index).P]];
            NoDealSeller(IrNoDealSeller) = [index, seller(index).P];
            IrNoDealSeller = IrNoDealSeller + 1;
        end

    end

    for index = 1:Nc

        if buyer(index).flag == 1
            % NoDealBuyer = [NoDealBuyer, [index, buyer(index).P]];
            NoDealBuyer(IrNoDealBuyer) = [index, buyer(index).P];
            IrNoDealBuyer = IrNoDealBuyer + 1;
        end

    end

    DealResults.Deal = pair;
    DealResults.NoDealSeller = NoDealSeller;
    DealResults.NoDealBuyer = NoDealBuyer;

end
