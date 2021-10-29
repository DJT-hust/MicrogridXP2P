function ConnectPair = ConncetionCheck(filename)
    [branch, Character_Data] = xlsread(filename, 'BranchData');
    FromBus=branch(:,1);
    ToBus=branch(:,2);
    
end