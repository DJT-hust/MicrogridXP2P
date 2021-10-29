clear
close all
clc

NPeer = 6;
% Res = zeros(NPeer, 1);
WindVelocity = [7.748213498	10.39230239	7.440926786	6.888384103	5.171564132	11.43549973	7.82341854	8.598863538	11.97653657	5.390938189	5.889097145	6.094312449	11.58007329	9.202232516	11.87314027	12.77441076	7.52915579	14.0916728	10.7235422	10.32821758	6.698487059	10.53057709	12.64947342	6.507564544;
            10.13950076	10.56178451	11.51441548	7.466272097	6.745199351	13.9385603	6.270678551	8.444704732	11.09632567	5.009758225	14.8795728	12.26833287	6.482716016	14.53394509	10.80094596	10.2496742	10.25154474	13.14785261	14.53278069	6.688123855	7.110961559	7.248425243	8.627134654	7.088340315;
            7.321104151	9.70302728	6.194352837	10.73261537	9.335786332	14.7668562	7.064268214	14.86064287	13.67527558	14.98161923	13.43660941	13.00512691	6.21204232	8.195290101	12.61871396	9.298012456	7.722583504	13.34653834	6.37417011	12.70910055	9.064746051	10.61040535	8.657127332	5.831085092;
            5.168564322	11.1721059	11.56505603	12.68876663	7.54790516	8.217837248	11.15913864	6.572595814	7.232464046	12.91022302	6.990113438	14.62546623	8.795310023	11.18045513	10.99678238	11.35533941	10.30618322	12.07616788	12.43234059	14.11950582	14.90716226	10.73630436	7.790770552	12.95999237;
            12.5442695	5.167943114	14.80655376	6.197466744	5.018638957	11.4555936	5.465089343	9.704847287	12.59732985	12.5595133	7.028081269	14.85710152	6.467343987	8.619810361	9.902718031	7.840180556	6.862222201	6.076254252	7.33612538	12.00310203	11.64210722	13.71388521	14.10748934	5.682229881;
            12.46154375	12.61692839	9.497538234	13.70672112	11.59416413	9.636376091	11.5115649	8.61176091	6.314033386	13.15412962	5.811027865	11.53591409	11.72764322	6.69217436	14.99332855	12.69423273	12.86360643	8.014341872	9.663923087	12.39695373	8.484207002	5.427441373	5.877797783	9.625684105
            ]; %created randomly using Excel
NTAR = [20 15 30 35 45 15];

for index = 1:NPeer
    [Res(index), PWFact(index, :),PWForecast(index, :)] = MicroGridSim(WindVelocity(index, :), NTAR(index));
    %     Res(index).name=['MG' int2str(index)];
end

for index = 1:NPeer
    %     [Res(index),PWFact(index,:)] = MicroGridSim(WindVelocity(index, :),NTAR(index));
    Res(index).name = ['MG' int2str(index)];
end

% Res.Ppurchase = value(Ppurchase);
% Res.Psale = value(Psale);
% Res.NM = value(NM);
% Res.NB = value(NB);
% Res.PW = value(PW);
% Res.PB = value(PB);
% Res.Dpmp = value(Dpmp);
% Res.SOC = value(SOC);
% Res.PMarket = value(PMarket);
PriceGrid = [];
OnPeakTime = [2, 7, 8, 9, 10, 11, 12, 17, 18, 19];

for index = 1:24

    if ismember(index, OnPeakTime)
        PriceGrid(index) = 0.16790;
    else
        PriceGrid(index) = 0.08274;
    end

end

% DealFlag = {};

for t = 1:24

    % if t ~= 1
    %     clear('seller');
    %     clear('buyer');
    %     clear('pair');
    %     clear('NoDealSeller');
    %     clear('NoDealBuyer');
    % end
    if exist('seller')
        clear('seller');
    end

    if exist('buyer')
        clear('buyer');
    end

    if exist('pair')
        clear('pair');
    end

    if exist('NoDealSeller')
        clear('NoDealSeller');
    end

    if exist('NoDealBuyer')
        clear('NoDealBuyer');
    end

    IrSeller = 1;
    IrBuyer = 1;

    for index = 1:NPeer

        if Res(index).PMarket(t) > 0
            seller(IrSeller).name = Res(index).name;
            seller(IrSeller).P = Res(index).Psale(t);
            seller(IrSeller).Ptemp = seller(IrSeller).P;
            seller(IrSeller).flag = 1;
            seller(IrSeller).price = OriginalPriceSeller(seller(IrSeller).P, PriceGrid(t));
            IrSeller = IrSeller + 1;
        elseif Res(index).PMarket(t) < 0
            buyer(IrBuyer).name = Res(index).name;
            buyer(IrBuyer).P = Res(index).Ppurchase(t);
            buyer(IrBuyer).Ptemp = buyer(IrBuyer).P;
            buyer(IrBuyer).flag = 1;
            buyer(IrBuyer).price = OriginalPriceBuyer(buyer(IrBuyer).P, PriceGrid(t));
            IrBuyer = IrBuyer + 1;
        end

    end

    if exist('seller') && exist('buyer')
        DealFlag(t) = 1; %Deal
        TableSeller = struct2table(seller); % convert the struct array to a table
        sortedTableSeller = sortrows(TableSeller, 'price'); % sort the table by 'DOB'
        seller = table2struct(sortedTableSeller); % change it back to struct array if necessary

        TableBuyer = struct2table(buyer); % convert the struct array to a table
        sortedTableBuyer = sortrows(TableBuyer, 'price'); % sort the table by 'DOB'
        buyer = table2struct(sortedTableBuyer); % change it back to struct array if necessary

        [Pair, NoDealSeller, NoDealBuyer] = DealBuySell(seller, buyer);
        PairRes(t) = {Pair};
        NoDealSellerRes(t) = {NoDealSeller};
        NoDealBuyerRes(t) = {NoDealBuyer};
    elseif exist('seller')
        DealFlag(t) = 2; %No buyer
        PairRes(t) = {[]};
        NoDealSellerRes(t) = {[]};
        NoDealBuyerRes(t) = {[]};
    elseif exist('buyer')
        DealFlag(t) = 3; %No seller
        PairRes(t) = {[]};
        NoDealSellerRes(t) = {[]};
        NoDealBuyerRes(t) = {[]};
    else
        DealFlag(t) = 4; %No buyer or seller
        PairRes(t) = {[]};
        NoDealSellerRes(t) = {[]};
        NoDealBuyerRes(t) = {[]};
    end

end

% save Result.mat
EleDistance = PTDCalculate('6BusCase_networkdata.xlsx'); %Calculate the electrical distance.
% buyerPayment = zeros(NPeer, 24);
% sellerCollection = zeros(NPeer, 24);
gamma = 0.001;

for t = 1:24

    if DealFlag(t) == 1
        N = size(PairRes{t}, 2);

        for index = 1:N
            buyerNo = str2num(PairRes{t}(index).buyername(3));
            sellerNo = str2num(PairRes{t}(index).sellername(3));
            PTD = EleDistance(sellerNo, buyerNo);
            price = PairRes{t}(index).price * PairRes{t}(index).power;
            % buyerPayment(buyerNo, t) = price + gamma * PTD * PairRes{t}(index).P;
            % sellerCollection(sellerNo, t) = price;
            PairRes{t}(index).BuyerTotalPrice=price + gamma * PTD * PairRes{t}(index).power;
            PairRes{t}(index).SellerTotalPrice=price;
        end

    end

end
