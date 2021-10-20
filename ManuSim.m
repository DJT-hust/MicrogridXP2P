function Res = ManuSim()
    Mech_Num = 6;
    Sche_len = 1;
    Tar_Num = 25;
    Buf_Num = Mech_Num -1;
    P_per_Mech = [48, 32, 12, 36, 32, 21];
    P_per_Buff = [4, 4, 4, 4, 4];
    PR_Mech_UB = [2, 2, 2, 2, 2, 2];
    PR_Mech_LB = [0, 0, 0, 0, 0, 0];
    PR_Buff_UB = [4, 4, 4, 4, 4];
    PR_Buff_LB = [0, 0, 0, 0, 0];
    Slot_Num = 24 / Sche_len;
    Constrain = [];

end
