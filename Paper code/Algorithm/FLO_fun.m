function FLO = FLO_fun(Popsize, Max_iter, dim, lb, ub, thres, fobj, XTRNf, YTRNf, XTSNf, YTS)


lb = ones(1, dim).*(lb);                              % Lower limit for variables
ub = ones(1, dim).*(ub);                              % Upper limit for variables
X = zeros(Popsize, dim);
%% INITIALIZATION
for i = 1: dim
    X(:, i) = lb(i)+rand(Popsize,1).*(ub(i) - lb(i));                          % Initial population
end

for i = 1: Popsize
    fit(i) = fobj( (X(i,:)>thres), XTRNf, YTRNf, XTSNf, YTS );
end

FLO_curve = zeros(1, Max_iter);

for t = 1: Max_iter  % algorithm iteration
    
    %%  update: BEST proposed solution
    [Fbest, blocation] = min(fit);
    
    if t == 1
        xbest = X(blocation, :);                                           % Optimal location
        fbest = Fbest;                                           % The optimization objective function
    elseif Fbest < fbest
        fbest = Fbest;
        xbest = X(blocation, :);
    end
    
    for i = 1: Popsize
        %% 3.3.1 Phase 1: Hunting strategy (exploration)candidate_preys
        prey_position = find( fit < fit(i) );% Eq(4)
        if size(prey_position, 2) == 0
            selected_prey = xbest;
        else
            if rand < 0.5
                selected_prey = xbest;
            else
                k = randperm(size(prey_position,2),1);
                selected_prey = X(prey_position(k));
            end
        end
        
        I = round(1 + rand);
        Xnew_P1 = X(i, :)+rand(1, 1).*(selected_prey-I.*X(i,:));%Eq(5)
        
        Xnew_P1 = max(Xnew_P1, lb);
        Xnew_P1 = min(Xnew_P1, ub);
        
        % update position based on Eq (6)
        
        fnew_P1 = fobj( (Xnew_P1>thres), XTRNf, YTRNf, XTSNf, YTS );
        if fnew_P1 < fit(i)
            X(i, :) = Xnew_P1;
            fit(i) = fnew_P1;
        end
        %% END Phase 1
        
        %% 3.3.2 Phase 2: Moving up the tree (exploitation)
        
        Xnew_P2 = X(i, :)+(1-2*rand).*((ub-lb)/t);%Eq(7)
        Xnew_P2 = max(Xnew_P2, lb./t);
        Xnew_P2 = min(Xnew_P2, ub./t);
        % update position based on Eq (8)
        fnew_P2 = fobj( (Xnew_P2>thres), XTRNf, YTRNf, XTSNf, YTS );
        if fnew_P2 < fit(i)
            X(i, :) = Xnew_P2;
            fit(i) = fnew_P2;
        end
        
    end
    
    FLO_curve(t) = fbest;
    fprintf('\nIteration %d Best (FLO)= %f', t, FLO_curve(t))
    
end

FLO.bestscore = fbest;
FLO.bestpos = xbest;
FLO.curve  = FLO_curve;

Pos   = 1: dim;
FLO.bestbinarypos = (FLO.bestpos > thres) == 1;
Sf    = Pos((xbest > thres) == 1);
FLO.sf = Sf;
FLO.nf = length(Sf);

end

