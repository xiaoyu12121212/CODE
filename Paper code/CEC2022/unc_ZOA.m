function [Best_score, Best_pos, uncZOA_curve] = unc_ZOA(Popsize, Max_iter, lb, ub, dim, fobj, n1, n2, n3)

%% 初始化
X = zeros(Popsize, dim);
lb = ones(1, dim).*(lb);
ub = ones(1, dim).*(ub);
for i = 1: dim
    X(:, i) = lb(i) + rand(Popsize, 1) .* (ub(i) - lb(i));
end

fit = zeros(Popsize, 1);
fbest = inf;
for i = 1: Popsize
    fit(i) = fobj( X(i, :) );
    if fit(i) < fbest
        PZ = X(i, :);
        fbest = fit(i);
    end
end

best_so_far = zeros(1, Max_iter);

%% 
Initial_Value = 0.65;

x = (chaos(n1, Initial_Value, Max_iter));
y = (chaos(n2, Initial_Value, Max_iter));

[theta, rho] = cart2pol(x, y);

switch n3
    case 1;  v = x;
    case 2;  v = y;
    case 3;  v = theta;
    case 4;  v = rho;
end

%% 


for t = 1: Max_iter


    %% PHASE1: Foraging Behaviour
    for i = 1: Popsize

        I = round(1 + rand);
        X_newP1 = ( 1.8*( 0.5-0.5*(2*(t/Max_iter)-1)^3 ) ) * v(t) * X(i, :) + rand(1, dim).*(PZ-I.* X(i, :));

        X_newP1 = max(X_newP1, lb);
        X_newP1 = min(X_newP1, ub);

        f_newP1 = fobj(X_newP1);
        if f_newP1 <= fit (i)
            X(i, :) = X_newP1;
            fit (i) = f_newP1;
        end

    end
    %% End Phase 1: Foraging Behaviour

    %% PHASE2: defense strategies against predators
    Ps = rand;
    k = randperm(Popsize, 1);
    AZ = X(k, :); % attacked zebra

    for i = 1: Popsize

        if Ps < 0.5
            %% S1: the lion attacks the zebra and thus the zebra chooses an escape strategy（逃跑）
            % R = 0.01;
            % X_newP2 = X(i, :) + R*(2*rand(1, dim)-1)*( 1-t/Max_iter ).*X(i, :);
            X_newP2 = X(i,:) + (rand+2*sin(pi/2*t/Max_iter))*rand(1, dim).* (X(i,:)-AZ);

            X_newP2 = max(X_newP2, lb);
            X_newP2 = min(X_newP2, ub);


        else
            %% S2: other predators attack the zebra and the zebra will choose the offensive strategy（恐吓）
            I = round(1+rand(1,1));
            X_newP2 = X(i, :) + rand(1, dim).*(AZ-I.* X(i,:));

            X_newP2 = max(X_newP2, lb);
            X_newP2 = min(X_newP2, ub);


        end

        f_newP2 = fobj( X_newP2 );
        if f_newP2 <= fit (i)
            X(i, :) = X_newP2;
            fit (i) = f_newP2;
        end

    end
    [best, location] = min(fit);
    PZ = X(location, :);       
    fbest = best;

    best_so_far(t) = fbest;


end

Best_score = fbest;
Best_pos = PZ;
uncZOA_curve = best_so_far;

end
