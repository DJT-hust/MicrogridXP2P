function Res = MicroGridSim(WindVelocity)
    Mech_Num = 6;
    Sche_len = 1;
    Tar_Num = 25;
    NPW = 350;
    Buf_Num = Mech_Num -1;
    P_per_Mech = [48, 32, 12, 36, 32, 21];
    P_per_Buff = [4, 4, 4, 4, 4];
    PR_Mech_UB = [2, 2, 2, 2, 2, 2];
    PR_Mech_LB = [0, 0, 0, 0, 0, 0];
    PR_Buff_UB = [4, 4, 4, 4, 4];
    PR_Buff_LB = [0, 0, 0, 0, 0];
    Slot_Num = 24 / Sche_len;
    Constrain = [];
    OnPeakTime = [2, 7, 8, 9, 10, 11, 12, 17, 18, 19];
    ElePrice = [];
    NTAR = 25;
    PDischarge = 3;
    PCharge = 3;

    for index = 1:size(OnPeakTime, 2)

        if ismember(index, OnPeakTime)
            ElePrice = [ElePrice, 0.16790];
        else
            ElePrice = [ElePrice, 0.08274];
        end

    end

    OfficeHighTime = [8:12, 14:17, 19:21];
    Doffice = 3 * ones(1, 24);
    Doffice(OfficeHighTime) = 10;

    Ppurchase = sdpvar(1, Slot_Num);
    NM = sdpvar(Mech_Num, Slot_Num);
    NB = sdpvar(Buf_Num, Slot_Num);
    PW = sdpvar(1, Slot_Num);
    PB = sdpvar(1, Slot_Num);
    Dpmp = sdpvar(1, Slot_Num);
    SOC = sdpvar(1, Slot_Num);
    PWFact = NPW * windpowermodel(WindVelocity);

    for t = 1:Slot_Num
        Constrain = [Constrain, PR_Mech_LB' <= NM(:, t) <= PR_Mech_UB'];
        Constrain = [Constrain, PR_Buff_LB' <= NB(:, t) <= PR_Buff_UB'];

        for i = 1:Mech_Num

            if i ~= 1 & t ~= 1
                Constrain = [Constrain, NM(i, t) <= PR_Mech_UB(i) + NB(i - 1, t - 1)];
            end

            if i ~= Mech_Num & t ~= 1
                Constrain = [Constrain, NB(i, t) + NM(i + 1, t - 1) = NB(i, t - 1) + NM(i, t - 1)];
            end

        end

        Constrain = [Constrain, sum(NM(:, t) .* P_per_Mech) + sum(NB(:, t) .* P_per_Buff) = Dpmp(t)];
        PWTemp = PWFact(t);
        Constrain = [Constrain, 0 <= PW(t) <= PWTemp];

    end

    Constrain = [Constrain, sum(NM(1:Mech_Num - 1, Slot_Num)) + sum(NB(:, Slot_Num)) = 0];
    Constrain = [Constrain, sum(NM(2:Mech_Num, 1)) + sum(NB(:, 1)) = 0];
    Constrain = [Constrain, sum(NM(Mech_Num, :)) >= NTAR];

end
