function NUM = FindData(t, MG, flag, PairRes)

    if flag == 0 %buyer
        N = size(PairRes{t}, 2);

        if N == 0
            NUM = 0;
        else
            temp = 0;
            sellername = {};
            IrName = 1;

            for index = 1:N

                if strcmp(PairRes{t}(index).buyername, MG)
                    sellername(IrName) = {PairRes{t}(index).sellername};
                    temp = temp + PairRes{t}(index).power;
                    IrName = IrName + 1;
                end

                NUM = temp;
%                 name = sellername;
            end

        end

    else
        N = size(PairRes{t}, 2);

        if N == 0
            NUM = 0;
        else
            temp = 0;
            buyername = {};
            IrName = 1;

            for index = 1:N

                if strcmp(PairRes{t}(index).sellername, MG)
                    buyername(IrName) = {PairRes{t}(index).buyername};
                    temp = temp + PairRes{t}(index).power;
                    IrName = IrName + 1;
                end

                NUM = temp;
%                 name = buyername;
            end

        end

    end

end
