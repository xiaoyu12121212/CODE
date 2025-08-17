function ZOA = ZOA_fun(Popsize, Max_iter, dim, lb, ub, thres, fobj, XTRNf, YTRNf, XTSNf, YTS)

Positions = zeros(Popsize, dim);
lowerbound = ones(1, dim) .* lb;
upperbound = ones(1, dim) .* ub;

for i = 1: dim
    Positions(:, i) = lowerbound(i) + rand(Popsize, 1) .* (upperbound(i) - lowerbound(i));
end

fit = zeros(Popsize, 1);
for i = 1: Popsize
    fit(i) = fobj( (Positions(i, :)>thres), XTRNf, YTRNf, XTSNf, YTS );
end

ZOA_curve = zeros(1, Max_iter);

for t = 1: Max_iter
    
    [best, location] = min(fit);
    if t == 1
        PZ = Positions(location, :);                                           % Optimal location
        fitG = best;                                           % The optimization objective function
    elseif best < fitG
        fitG = best;
        PZ = Positions(location, :);
    end
    
    for i = 1: Popsize
        % PHASE 1: Moving towards prey (exploration phase)
        I = round(1 + rand(1, 1));
        X_newP1 = Positions(i, :) + rand(1, dim).*(PZ-I.* Positions(i, :)); % Eq(3)  % ***

        for var = 1: length(X_newP1)
            if X_newP1(var)> upperbound(var) || X_newP1(var) < lowerbound(var)
                X_newP1 = lowerbound + (upperbound-lowerbound)*rand;
            end
        end
        
        f_newP1 = fobj( (X_newP1 > thres), XTRNf, YTRNf, XTSNf, YTS );
        if f_newP1 <= fit(i)
            Positions(i, :) = X_newP1;
            fit(i) = f_newP1;
        end
        
    end
    
    Ps = rand;
    k = randperm(Popsize, 1);
    AZ = Positions(k, :); % attacked zebra
    
    for i = 1: Popsize
        if Ps < 0.5
            % S1: the lion attacks the zebra and thus the zebra chooses an escape strategy
            R = 0.01;
            X_newP2 = Positions(i, :)+ R*(2 * rand(1, dim)-1)*(1 - t/Max_iter).*Positions(i, :);% Eq.(5) S1 % ***

        else
            % S2: other predators attack the zebra and the zebra will choose the offensive strategy
            I = round(1 + rand(1, 1));
            X_newP2 = Positions(i, :) + rand(1, dim).*(AZ-I.* Positions(i, :)); %Eq(5) S2      % ***

        end

        for var = 1: length(X_newP2)
            if X_newP2(var)> upperbound(var) || X_newP2(var) < lowerbound(var)
                X_newP2 = lowerbound + (upperbound-lowerbound)*rand;
            end
        end
        
        f_newP2 = fobj( (X_newP2 > thres), XTRNf, YTRNf, XTSNf, YTS ); %Eq (6)  % ***
        if f_newP2 <= fit(i)
            Positions(i, :) = X_newP2;
            fit(i) = f_newP2;
        end
        
    end
    
    ZOA_curve(t) = fitG;
    % Save
    fprintf('\nIteration %d Best (ZOA)= %f', t, ZOA_curve(t))
    
end

ZOA.bestscore = fitG;
ZOA.bestpos = PZ;
ZOA.curve  = ZOA_curve;

Pos   = 1: dim;
ZOA.bestbinarypos = (ZOA.bestpos > thres) == 1;
Sf    = Pos((PZ > thres) == 1);
ZOA.sf = Sf;
ZOA.nf = length(Sf);

end

