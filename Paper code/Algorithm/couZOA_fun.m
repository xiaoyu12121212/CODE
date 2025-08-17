function couZOA = couZOA_fun(Popsize, Max_iter, dim, lb, ub, thres, fobj, XTRNf, YTRNf, XTSNf, YTS)


X = zeros(Popsize, dim);
lowerbound = ones(1, dim) .* lb;
upperbound = ones(1, dim) .* ub;
for i = 1: dim
    X(:, i) = lowerbound(i) + rand(Popsize, 1) .* (upperbound(i) - lowerbound(i));
end

fit = zeros(Popsize, 1);
fbest = inf;
for i = 1: Popsize
    fit(i) = fobj( (X(i, :)>thres), XTRNf, YTRNf, XTSNf, YTS );
    if fit(i) < fbest
        PZ = X(i, :);
        fbest = fit(i);
    end
end

couZOA_Curve = zeros(1, Max_iter);

%%
x = zeros(1, Max_iter);
y = zeros(1, Max_iter);

x(1) = 0.55;
y(1) = 0.45;

for t = 1: Max_iter

    % s2
    x(t+1) = x(t)-0.2*( x(t)^12+y(t)^12-1 );
    y(t+1) = y(t)+2.4*x(t)*y(t)*( x(t)^12+y(t)^12-1 );

end

[theta, rho] = cart2pol(x, y);
v = rho;

for t = 1: Max_iter

    %% PHASE1: Foraging Behaviour
    for i = 1: Popsize

        I = round(1 + rand);
        X_newP1 = ( 2*( 0.5-0.5*(2*(t/Max_iter)-1)^3 ) ) * v(t) * X(i, :) + rand(1, dim) .* (PZ - I.* X(i, :)); %Eq(3)

        X_newP1 = max(X_newP1, lb);
        X_newP1 = min(X_newP1, ub);

        f_newP1 = fobj( (X_newP1 > thres), XTRNf, YTRNf, XTSNf, YTS );
        if f_newP1 <= fit(i)
            fit(i) = f_newP1;
        end

    end
    %% End Phase 1: Foraging Behaviour

    %% PHASE2: defense strategies against predators
    Ps = rand();
    i = randperm(Popsize, 1);
    AZ = X(i, :); % attacked zebra

    for i = 1: Popsize

        if Ps < 0.5
            %% S1: the lion attacks the zebra and thus the zebra chooses an escape strategy

            X_newP2 = X(i,:) + (rand+2*sin(pi/2*t/Max_iter))*rand(1, dim).* (X(i,:)-AZ);

            X_newP2 = max(X_newP2, lb);
            X_newP2 = min(X_newP2, ub);
        else
            %% S2: other predators attack the zebra and the zebra will choose the offensive strategy

            I = round(1+rand(1, 1));
            X_newP2 = X(i, :) + rand(1, dim).*(AZ-I.* X(i, :)); %Eq(5) S2

            X_newP2 = max(X_newP2, lb);
            X_newP2 = min(X_newP2, ub);
        end

        f_newP2 = fobj( (X_newP2 > thres), XTRNf, YTRNf, XTSNf, YTS ); %Eq (6)

        if f_newP2 <= fit (i)
            X(i, :) = X_newP2;
            fit(i) = f_newP2;
        end

    end

    [best, location] = min(fit);
    PZ = X(location, :);         % Optimal location
    fbest = best;

    couZOA_Curve(t) = fbest;
    fprintf('\nIteration %d Best (couZOA)= %f', t, couZOA_Curve(t))

end %t=1:Max_iterations

couZOA.bestscore = fbest;
couZOA.bestpos = PZ;
couZOA.curve = couZOA_Curve;

Pos   = 1: dim;
couZOA.bestbinarypos = (couZOA.bestpos > thres) == 1;
Sf    = Pos((PZ > thres) == 1);
couZOA.sf = Sf;
couZOA.nf = length(Sf);

end








