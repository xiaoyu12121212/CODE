%  %  Main paper:                                                                                        
%  E. Tanyildizi, G. Demir, "Golden Sine Algorithm: A Novel Math-Inspired Algorithm," Advances in Electrical and Computer Engineering, vol.17, no.2, pp.71-78, 2017, doi:10.4316/AECE.2017.02010
%__________________________________________
% func_obj = @CostFunction
% dim = number of your variables
% Max_iteration = maximum number of iterations
% Population = number of search agents
% Lb=Lower bound
% Ub=Upper bound


% To run GoldSA: [Best_value,Best_pos]=GoldSA(Population,Max_iteration,Lb,Ub,dim,func_obj)
%______________________________________________________________________________________________


function GSA = GSA_fun(Popsize, Max_iter, dim, lb, ub, thres, fobj, XTRNf, YTRNf, XTSNf, YTS)

X = initialization(Popsize,dim,ub,lb);

GSA_pos = zeros(1, dim);
GSA_value = inf;
GSA_curve = zeros(1, Max_iter);
Destination_values = zeros(1, size(X, 1));

% Calculate the fitness of the first set and find the best one
for i = 1: size(X, 1)
    Destination_values(1, i) = fobj( (X(i, :)>thres), XTRNf, YTRNf, XTSNf, YTS );
    if i == 1
        GSA_pos = X(i, :);
        GSA_value = Destination_values(1, i);
    elseif Destination_values(1, i) < GSA_value
        GSA_pos = X(i, :);
        GSA_value = Destination_values(1, i);
    end
 
end

a = pi;                           
b = -pi;
gold = ((sqrt(5)-1)/2);      % golden proportion coefficient, around 0.618
x1 = a+(1-gold)*(b-a);          
x2 = a+gold*(b-a);

%Main loop
t = 1; 
while t<=Max_iter
       
    
    % Update the position of solutions with respect to objective
    for i=1:size(X,1) % in i-th solution
        r=rand;
        r1=(2*pi)*r;
        r2=r*pi; 
        for j=1:size(X,2) % in j-th dimension
           
            X(i,j)= X(i,j)*abs(sin(r1)) - r2*sin(r1)*abs(x1*GSA_pos(j)-x2*X(i,j));
            
        end
    end
    
    for i=1:size(X,1)
        
        % Check if solutions go outside the search spaceand bring them back
        Boundary_Ub=X(i,:)>ub;
        Boundary_Lb=X(i,:)<lb;
        X(i,:)=(X(i,:).*(~(Boundary_Ub+Boundary_Lb)))+ub.*Boundary_Ub+lb.*Boundary_Lb;
        
        % Calculate the objective values
        Destination_values(1,i) = fobj( (X(i, :)>thres), XTRNf, YTRNf, XTSNf, YTS );
        
        % Update the destination if there is a better solution
        if Destination_values(1,i)<GSA_value
            GSA_pos=X(i,:);
            GSA_value=Destination_values(1,i);
            b=x2;
            x2=x1;
            x1=a+(1-gold)*(b-a);
        else
            a=x1;
            x1=x2;
            x2=a+gold*(b-a);
            
        end
        
        if x1==x2
            a=-pi*rand; 
            b=pi*rand;
            x1=a+(1-gold)*(b-a); 
            x2=a+gold*(b-a);
            
        end
        
    end
    
    GSA_curve(t) = GSA_value;
    fprintf('\nIteration %d Best (GSA)= %f', t, GSA_curve(t))
    
    t=t+1;
    
end

GSA.bestscore = GSA_value;
GSA.bestpos = GSA_pos;
GSA.curve  = GSA_curve; 

Pos   = 1: dim;
GSA.bestbinarypos = (GSA.bestpos > thres) == 1;
Sf    = Pos((GSA_pos > thres) == 1); 
GSA.sf = Sf;
GSA.nf = length(Sf);


end