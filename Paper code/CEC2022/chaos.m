
function O=chaos(index,Initial_Value,N)

x(1)=Initial_Value;
switch index

    case 1
        % Circle map
        a=0.5;
        b=0.2;
        for t=1:N
            x(t+1)=mod(x(t)+b-(a/(2*pi))*sin(2*pi*x(t)),1);
        end

    case 2
        % Singer map
        u=1.07;
        for t=1:N
            x(t+1) = u*(7.86*x(t)-23.31*(x(t)^2)+28.75*(x(t)^3)-13.302875*(x(t)^4));
        end

    case 3 
        % ICMIC map
        a =4;
        for t=1:N
             x(t+1) = sin(a/x(t));            
        end
   
    case 4
        % Bernoulli map
        r=0.5;
        for t=1:N
            if x(t)>=0 && x(t)<=1-r
                x(t+1)=x(t)/(1-r);
            else
                x(t+1)=(x(t)-1+r)/r;   
            end
        end
      
end
O=x(1:N);
end
