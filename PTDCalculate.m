function PTD = PTDCalculate(filename)
    PTDF = PTDFCalculate(filename);
    PTD = [];

    for index = 1:6

        for jndex = 1:6
            PTD(index, jndex) = CalculateOnePTD(index, jndex, PTDF, filename);
        end

    end

end
