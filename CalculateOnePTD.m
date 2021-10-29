function PTD = CalculateOnePTD(S_injection_bus, R_removal_bus, PTDF,filename)
    %from:https://github.com/sgbbhat/Distribution_Factors
    % changed by JTDuan in 2021/10/26
    %the bus_connections matrix is same as the B matrix
    % bus_connections = B;
    bus_connections = [1	1	0	1	1	0;
                    1	1	1	1	1	1;
                    0	1	1	0	1	1;
                    1	1	0	1	1	0;
                    1	1	1	1	1	1;
                    0	1	1	0	1	1];
    numbus = size(bus_connections, 1);
    [branch, ~] = xlsread(filename, 'BranchData');
    numline = size(branch, 1);

    for iline = 1:numline
        frombus(iline) = branch(iline, 1);
        tobus(iline) = branch(iline, 2);
    end

    % this portion of the code from line 14 to 27 replaces the non-zero
    % elements of the the bus_connections matrix with '1'

    for i = 1:numbus

        for j = 1:numbus

            if bus_connections(i, j) ~= 0
                bus_connections(i, j) = 1;
            else
                bus_connections(i, j) = 0;
                j = j + 1;
            end

        end

        i = i + 1;
    end

    Res = findPath(1 ./ bus_connections, S_injection_bus, R_removal_bus, 0);
    Path = Res(:, 1:(size(Res, 2) - 1));
    dist = Res(:, size(Res, 2));
    %Create biograph object (biograph is a Data structure containing generic
    %interconnected data to implement a graph

    %now suppose we are injecting power into bus 2 and removing it at bus 8.
    %Let's say, the shortest path is from 2->5->8. The 'PTDF_s_to_r' matrix stores the
    %PTDF values of all lines corresponding to the transaction between 2->5 %and 5->8.
    %Since there is a line between 2->5 and 5->8, we can extract
    %the PTDF coulumns (2->5 and 5->8) from the PTDF table and sum them up
    %to give us the PTDF of all lines corresponding to a transaction between 2->8.

    % This part of the code is difficult to understand as I have written it in a bad way.
    % Basically we traverse the 'frombus' and 'tobus' arrays until we reach the
    % desired line. In the first iteration for = 1: dist, we reach the line 2->5
    %and in the next iteration we reach line 5->8.

    count = 0;
    k = 0;
    i = 0;
    j = 0;
    PTDF_s_to_r = [];
    PTD = 0;

    for index = 1:size(Path, 1)
        path = Path(index, :);

        for i = 1:dist(index)

            S_injection_bus = path(i);
            R_removal_bus = path(i + 1);

            for j = 1:numline

                if frombus(j) == S_injection_bus

                    for k = 1:j

                        if tobus(k) == R_removal_bus

                            if j == k
                                count = 1;
                                break;
                            end

                        end

                    end

                end

                if count == 1
                    break;
                end

            end

            count = 0;

            % we append the PTDF columns into the PTDF_S_to_r matrix
            PTDF_s_to_r = [PTDF_s_to_r PTDF(:, j)];

        end

        % we perform column wise addition to the get the final PTDF values.

        PTD = PTD + sum(sum(abs(PTDF_s_to_r), 2));
    end

end
