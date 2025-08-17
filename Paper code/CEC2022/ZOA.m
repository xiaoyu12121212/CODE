function[Best_score,Best_pos,ZOA_curve]=ZOA(N,Max_iter,lowerbound,upperbound,dim,fobj)

lowerbound=ones(1,dim).*(lowerbound);                              % Lower limit for variables
upperbound=ones(1,dim).*(upperbound);                              % Upper limit for variables

%% INITIALIZATION
for i=1:dim
    X(:,i) = lowerbound(i)+rand(N,1).*(upperbound(i) - lowerbound(i));                          % Initial population
end

for i =1:N
    L=X(i,:);
    fit(i)=fobj(L);
end
%%

for t=1:Max_iter
    %% update the global best (fbest)
    [best, location]=min(fit);
    if t==1
        PZ=X(location,:);                                           % Optimal location
        fbest=best;                                           % The optimization objective function
    elseif best<fbest
        fbest=best;
        PZ=X(location,:);
    end
    
    %% PHASE1: Foraging Behaviour
    for i=1:N
        
        I=round(1+rand);
        X_newP1=X(i,:)+ rand(1,dim).*(PZ-I.* X(i,:)); %Eq(3)
        X_newP1= max(X_newP1,lowerbound);X_newP1 = min(X_newP1,upperbound);
        
        
        % Updating X_i using (5)
        f_newP1 = fobj(X_newP1);
        if f_newP1 <= fit (i)
            X(i,:) = X_newP1;
            fit (i)=f_newP1;
        end

    end
    %% End Phase 1: Foraging Behaviour
    
    %% PHASE2: defense strategies against predators
    Ps=rand;
    k=randperm(N,1);
    AZ=X(k,:);% attacked zebra
    
    for i=1:N
        
        if Ps<0.5
            %% S1: the lion attacks the zebra and thus the zebra chooses an escape strategy
            R=0.01;
            X_newP2= X(i,:)+ R*(2*rand(1,dim)-1)*(1-t/Max_iter).*X(i,:);% Eq.(5) S1
            X_newP2= max(X_newP2,lowerbound);X_newP2 = min(X_newP2,upperbound);
      
        else
            %% S2: other predators attack the zebra and the zebra will choose the offensive strategy
            
            I=round(1+rand(1,1));
            X_newP2=X(i,:)+ rand(1,dim).*(AZ-I.* X(i,:)); %Eq(5) S2
            X_newP2= max(X_newP2,lowerbound);X_newP2 = min(X_newP2,upperbound);
             
        end
        
        f_newP2 = fobj(X_newP2); %Eq (6)
        if f_newP2 <= fit (i)
            X(i,:) = X_newP2;
            fit (i)=f_newP2;
        end

    end %
    %%
    %%
    
    best_so_far(t)=fbest;
    average(t) = mean (fit);
    
end % t=1:Max_iterations

Best_score=fbest;
Best_pos=PZ;
ZOA_curve=best_so_far;

end

