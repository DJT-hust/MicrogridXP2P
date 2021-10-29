function PTDF = PTDFCalculate(S)
    % 摘自:https://github.com/sgbbhat/Distribution_Factors
    % 计算PTDF
    % 段钧韬
    % 2021年10月24日
    print_flag = 1;

    % network_datainput_Excel
    %pfdatainput
    % Power flow data input, build Y matrix

    [Parameter_data, Parameter_Character_Data] = xlsread(S, 'Parameters');
    [bus, Character_Data] = xlsread(S, 'BusData');
    [gen, Character_Data] = xlsread(S, 'GenData');
    [branch, Character_Data] = xlsread(S, 'BranchData');
    [area, Character_Data] = xlsread(S, 'AreaData');
    [areanamedata, areaname] = xlsread(S, 'AreaName');

    baseMVA = Parameter_data(1);
    baseKV = Parameter_data(2);
    casemult = Parameter_data(3);
    Rmult = Parameter_data(4);
    varlimit = cell2mat(Parameter_Character_Data(5, 2));
    powerflow_tolerance = Parameter_data(6);
    Maxiter = Parameter_data(7);
    LPOPF_convergence = Parameter_data(8);
    delta_upper = Parameter_data(9);
    delta = Parameter_data(10);
    tau = Parameter_data(11);
    gamma = Parameter_data(12);
    nu = Parameter_data(13);
    printpowerflow_convergence = Parameter_data(14);
    printpowerflow_bussummary = Parameter_data(15);
    printLPmove_summary = Parameter_data(16);
    print_summary_graphs = Parameter_data(17);
    Contingency_Limits = Parameter_data(18);
    climadj = Parameter_data(19);
    Line_flow_limits = Parameter_data(20);
    printfactorsflag = Parameter_data(21);

    [numbus, N] = size(bus);
    [numline, N] = size(branch);
    [numgen, N] = size(gen);
    [numarea, N] = size(area);

    Bustype = zeros(1, numbus);
    Bustype_start = zeros(1, numbus);

    for ibus = 1:numbus
        Bustype(ibus) = ' ';
    end

    Pload = zeros(1, numbus);
    Qload = zeros(1, numbus);
    Vmax = zeros(1, numbus);
    Vmin = zeros(1, numbus);

    frombus = zeros(1, numline);
    tobus = zeros(1, numline);
    R = zeros(1, numline);
    X = zeros(1, numline);
    Bcap = zeros(1, numline);
    flowmax = zeros(1, numline);
    BranchStatus = zeros(1, numline);
    Vsched = zeros(1, numgen);
    Pgen = zeros(1, numgen);
    Qgen = zeros(1, numgen);
    Pmax = zeros(1, numgen);
    Pmin = zeros(1, numgen);
    Qmax = zeros(1, numgen);
    Qmin = zeros(1, numgen);
    genbus = zeros(1, numgen);
    busgen = zeros(1, numbus);
    original_genbus = zeros(1, numgen);

    for ibus = 1:numbus
        bustype_number = bus(ibus, 2);

        if bustype_number == 1
            Bustype(ibus) = 'L';
        end

        if bustype_number == 2
            Bustype(ibus) = 'G';
        end

        if bustype_number == 3
            Bustype(ibus) = 'S';
            refbus = ibus;
        end

        Bustype_start(ibus) = Bustype(ibus);
        Pload(ibus) = bus(ibus, 3) * casemult / baseMVA;
        Qload(ibus) = bus(ibus, 4) * casemult / baseMVA;
        Vmax(ibus) = bus(ibus, 12);
        Vmin(ibus) = bus(ibus, 13);
    end

    for igen = 1:numgen
        ibus = gen(igen, 1);
        genbus(igen) = ibus;
        busgen(ibus) = igen;
        original_genbus(igen) = ibus;
        Pgen(igen) = gen(igen, 2) * casemult / baseMVA;
        Qgen(igen) = gen(igen, 3) * casemult / baseMVA;
        Pmax(igen) = gen(igen, 9) / baseMVA;
        Pmin(igen) = gen(igen, 10) / baseMVA;
        Qmax(igen) = gen(igen, 4) / baseMVA;
        Qmin(igen) = gen(igen, 5) / baseMVA;

        if varlimit == 'N'
            Qmax(igen) = 99.;
            Qmin(igen) = -99.;
        end

        Vsched(igen) = gen(igen, 6);
    end

    for iline = 1:numline
        frombus(iline) = branch(iline, 1);
        tobus(iline) = branch(iline, 2);
        X(iline) = branch(iline, 4);
        flowmax(iline) = branch(iline, 6);
        BranchStatus(iline) = branch(iline, 11);
    end

    Y = zeros(numbus, numbus);

    for iline = 1:numline

        if BranchStatus(iline) == 1
            Y(frombus(iline), tobus(iline)) = Y(frombus(iline), tobus(iline)) - 1 / (sqrt(-1) * X(iline));
            Y(tobus(iline), frombus(iline)) = Y(tobus(iline), frombus(iline)) - 1 / (sqrt(-1) * X(iline));
        end

    end

    for ibus = 1:numbus
        Y(ibus, ibus) = -sum(Y(ibus, :));
    end

    for iline = 1:numline

        if BranchStatus(iline) == 1
            Y(frombus(iline), frombus(iline)) = Y(frombus(iline), frombus(iline)) + sqrt(-1) * Bcap(iline) / 2;
            Y(tobus(iline), tobus(iline)) = Y(tobus(iline), tobus(iline)) + sqrt(-1) * Bcap(iline) / 2;
        end

    end

    B = sparse(imag(Y));

    xline = X;
    Slack = refbus;

    %Init voltage and angle Variables
    v = ones(1, numbus);
    angle = zeros(1, numbus);
    v = bus(:, 8);
    angle = bus(:, 9) * (pi / 180);

    for igen = 1:numgen
        ibus = genbus(igen);
        v(ibus) = Vsched(igen);
    end

    nbus = numbus; % Number of buses
    ncircuits = numline; % Number of Interfaces between buss

    for iline = 1:numline
        fbus(iline) = frombus(iline);
        tbus(iline) = tobus(iline);
        xckt(iline) = X(iline);
        flowmax_perckt(iline) = flowmax(iline);
        monitor_circuit(iline) = BranchStatus(iline);
    end

    % DataSetUp
    for ibus = 1:numbus

        if Bustype(ibus) == 'S'
            refbus = ibus;
        end

    end

    % The model is made up of buss connected by transmission paths. Each transmission
    % path is made up of one or more circuits in parallel.
    % fbus is the FROM bus number for the path
    % tobus is the TO bus number for the path
    % xckt is the inductive reactance of the circuit making up the path
    % flowmax is the max MW flow in each line

    % if Line_flow_limits = 1 the limits will go in as entered on spreadsheet
    % if Line_flow_limits = 0 line flow limits ignored

    flowmax_multiplier = 1;

    if Line_flow_limits == 0
        flowmax_multiplier = 100.; % set to 100 all limits will be so large that they will never be met
    end

    % if Contingency_Limits = 1 the limits will go in as entered on spreadsheet
    %         times contingency limits adjustment variable climadj
    % if Contingency_Limits = 0 line flow limits ignored

    contingency_flowmax_multiplier = climadj;

    if Contingency_Limits == 0
        contingency_flowmax_multiplier = 100.; % set to 100 all limits will be so large that they will never be met
    end

    for iline = 1:numline
        fbus(iline) = frombus(iline);
        tbus(iline) = tobus(iline);
        xline(iline) = X(iline);
    end

    for ibus = 1:numbus
        Pload_fix(ibus) = Pload(ibus) * baseMVA;
    end

    % BIDDING DATA
    % Each function represents the cost of power at a generator

    % Each bid must have a separate function associated with it. The functions, C(P) and
    % W(P) are quadratic functions. GENERATION asking price function and LOAD worth of
    % power function.

    % Both the asking price of power, C(P) and the worth of power, W(P) functions are
    % quadratic functions:

    %  C(P) = A + B*P + C*P^2   and   W(P)= A + B*P + C*P^2
    %
    % where A = bidA
    %       B = bidB
    %       C = bidC

    % in all the examples here the A coefficient is zero
    % the coefficients for C(P) should all be positive or zero
    % the coefficients for W(P) should all be negative or zero

    % In addition, the bids have a min (bidmin) and a max (bidmax)
    % for generators bidmin and bidmax are the min and max generation output respectively
    % for loads midmin and bidmax are the min and max MW to be taken by the load.

    % Finally, each bid is associated with one bus (here each bus has one bus so you can
    % think of the bus number as being the same as the bus number in the bus

    for igen = 1:numgen

        ftnmin(igen) = Pmin(igen) * baseMVA;
        ftnmax(igen) = Pmax(igen) * baseMVA;
        ftnbus(igen) = genbus(igen);

    end

    flow = zeros(numline, numbus);
    B = zeros(numbus, numbus);
    Bx = zeros(numbus, numbus);
    X = zeros(numbus, numbus);
    Pload_var = zeros(1, numbus);
    Pnetbase = zeros(numbus, 1);
    gencost = zeros(numgen, 1);
    lambda_gen = zeros(numgen, 1);
    lambda_contingency = zeros(numline, 1);
    contsave = zeros(numline, 4);
    contdetected = zeros(numline, numline);

    % Calculate LODF factors
    % dfactcalc;
    % calc_FACTORS
    PTDF = zeros(numline, numline); % PTDF matrix
    RadialLines = zeros(1, numline); % table of lines shows radials
    Bx = zeros(numbus, numbus); % Bx matrix
    Bd = zeros(numline, numline); % diagonal matrix only
    A = zeros(numline, numbus); % line incidence matrix
    flow = zeros(numline, numbus); % line flow matrix

    for iline = 1:numline

        if BranchStatus(iline) == 1
            i = frombus(iline);
            j = tobus(iline);
            flow(iline, i) = 1.0 / xline(iline);
            flow(iline, j) = -1.0 / xline(iline);
        end

    end

    % build Bx matrix
    for iline = 1:numline

        if BranchStatus(iline) == 1
            Bx(frombus(iline), tobus(iline)) = Bx(frombus(iline), tobus(iline)) - 1 / xline(iline);
            Bx(tobus(iline), frombus(iline)) = Bx(tobus(iline), frombus(iline)) - 1 / xline(iline);
            Bx(frombus(iline), frombus(iline)) = Bx(frombus(iline), frombus(iline)) + 1 / xline(iline);
            Bx(tobus(iline), tobus(iline)) = Bx(tobus(iline), tobus(iline)) + 1 / xline(iline);
        end

    end

    B = Bx;

    % zero row and col for refbus, then put 1 in diag so we can invert it
    Bx(:, refbus) = zeros(numbus, 1);
    Bx(refbus, :) = zeros(1, numbus);
    Bx(refbus, refbus) = 1.0;

    % get X matrix for use in DC Power Flows
    Xmatrix = MatrixInverse(Bx);
    Xmatrix(refbus, refbus) = 0; % set the diagonal at the ref bus to zero for a short to ground
    % Xmatrix;

    for iline = 1:numline

        if BranchStatus(iline) == 1
            i = frombus(iline);
            j = tobus(iline);
            Bd(iline, iline) = 1.0 / xline(iline);
            A(iline, i) = 1.0;
            A(iline, j) = -1.0;
        end

    end

    B_diag = sparse(Bd);

    %Determine Radial Lines
    NumberOfLines_matrix = A' * A;
    NumberOfLines = diag(NumberOfLines_matrix);
    radial_bus_location = [];
    radial_bus_location = find(NumberOfLines == 1);
    % radial_bus_location

    num_radialline = 0;

    for n = 1:length(radial_bus_location)
        radial_bus = radial_bus_location(n);

        for iline = 1:numline

            if BranchStatus(iline) == 1

                if radial_bus == frombus(iline)
                    num_radialline = num_radialline + 1;
                    RadialLines(iline) = 1;
                end

            end

        end

    end

    for n = 1:length(radial_bus_location)
        radial_bus = radial_bus_location(n);

        for iline = 1:numline

            if BranchStatus(iline) == 1

                if radial_bus == tobus(iline)
                    num_radialline = num_radialline + 1;
                    RadialLines(iline) = 1;
                end

            end

        end

    end

    % RadialLines
    line_location_connecting_radial_bus = [];
    line_location_connecting_radial_bus = find(RadialLines == 1);

    % alter A and Bx to reflect radial lines, used only in LODF calculations
    A_alt = sparse(A);
    Bx_alt = sparse(Bx);

    %Create A_alt matrix to account for radial lines
    for iline = 1:numline

        if BranchStatus(iline) == 1

            if RadialLines(iline) == 1
                radial_bus = radial_bus_location(find(iline == line_location_connecting_radial_bus));
                A_alt(iline, radial_bus) = 0;
            end

        end

    end

    % Create Bx_alt matrix to account for radial lines
    for ibus = 1:numbus

        if NumberOfLines(ibus) == 0 | ibus == refbus

            for jbus = 1:numbus
                Bx_alt(ibus, jbus) = 0;
            end

            Bx_alt(ibus, ibus) = 1;
        end

    end

    X_alt = MatrixInverse(Bx_alt);
    X_alt(refbus, refbus) = 0; % set the diagonal at the ref bus to zero for a short to ground

    % basic expression for PTDF matrix which includes the PTDF(K,K) on
    % diagonals and is compensated for radial lines.

    PTDF = B_diag * A_alt * X_alt * A_alt';

    % set PTDF diagonal to zero for radial lines
    for iline = 1:numline

        if RadialLines(iline) == 1
            PTDF(iline, iline) = 0;
        end

    end

end
