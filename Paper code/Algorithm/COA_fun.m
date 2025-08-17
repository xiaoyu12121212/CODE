function COA = COA_fun(Popsize, Max_iter, dim, lb, ub, thres, fobj, XTRNf, YTRNf, XTSNf, YTS)

lb = ones(1, dim).*(lb);                              % Lower limit for variables
ub = ones(1, dim).*(ub);                              % Upper limit for variables

%% INITIALIZATION
for i = 1: dim
    X(:, i) = lb(i)+rand(Popsize, 1).*(ub(i) - lb(i));                          % Initial population
end

for i = 1: Popsize
    fit(i) = fobj( (X(i,:)>thres), XTRNf, YTRNf, XTSNf, YTS );
end

for t=1:Max_iter
    %% update the best condidate solution
    [best, location] = min(fit);
    if t == 1
        Xbest = X(location, :);                                           % Optimal location
        fbest = best;                                           % The optimization objective function
    elseif best < fbest
        fbest = best;
        Xbest = X(location, :);
    end
    
    for i = 1: Popsize/2
        
        %% Phase1: Hunting and attacking strategy on iguana (Exploration Phase)
        iguana = Xbest;
        I = round(1+rand(1,1));
        
        X_P1 = X(i, :)+rand(1,1) .* (iguana-I.*X(i,:)); % Eq. (4)
        X_P1 = max(X_P1, lb);
        X_P1 = min(X_P1, ub);
        
        % update position based on Eq (7)
        F_P1 = fobj( (X_P1>thres), XTRNf, YTRNf, XTSNf, YTS );
        if ( F_P1 < fit(i) )
            X(i, :) = X_P1;
            fit(i) = F_P1;
        end
        
    end
    
    for i = 1+Popsize/2: Popsize
        
        iguana = lb+rand.*(ub-lb); %Eq(5)
        L = iguana;
        F_HL = fobj( (L>thres), XTRNf, YTRNf, XTSNf, YTS );
        I = round(1+rand(1,1));
        
        if fit(i) > F_HL
            X_P1 = X(i, :)+rand(1,1) .* (iguana-I.*X(i, :)); % Eq. (6)
        else
            X_P1 = X(i,:)+rand(1,1) .* (X(i, :)-iguana); % Eq. (6)
        end
        X_P1 = max(X_P1,lb);
        X_P1 = min(X_P1,ub);
        
        % update position based on Eq (7)
        F_P1 = fobj( (X_P1>thres), XTRNf, YTRNf, XTSNf, YTS );
        if(F_P1 < fit(i))
            X(i, :) = X_P1;
            fit(i) = F_P1;
        end
    end
    %% END Phase1: Hunting and attacking strategy on iguana (Exploration Phase)
    
    %% Phase2: The process of escaping from predators (Exploitation Phase)
    for i = 1: Popsize
        LO_LOCAL = lb/t;% Eq(9)
        HI_LOCAL = ub/t;% Eq(10)
        
        X_P2 = X(i, :)+(1-2*rand).* (LO_LOCAL+rand(1,1) .* (HI_LOCAL-LO_LOCAL)); % Eq. (8)
        X_P2 = max(X_P2, LO_LOCAL);
        X_P2 = min(X_P2, HI_LOCAL);
        
        % update position based on Eq (11)
        F_P2 = fobj( (X_P2>thres), XTRNf, YTRNf, XTSNf, YTS );
        if( F_P2 < fit(i) )
            X(i, :) = X_P2;
            fit(i) = F_P2;
        end
        
    end
    %% END Phase2: The process of escaping from predators (Exploitation Phase)
    
    COA_curve(t)=fbest;
    fprintf('\nIteration %d Best (COA)= %f', t, COA_curve(t))
    
end

COA.bestscore = fbest;
COA.bestpos = Xbest;
COA.curve  = COA_curve;

Pos   = 1: dim;
COA.bestbinarypos = (COA.bestpos > thres) == 1;
Sf    = Pos((Xbest > thres) == 1);
COA.sf = Sf;
COA.nf = length(Sf);


end

