clc; clear; //clears the console and all previously stored variables

function V_0 = CRR_AmPut(S_0, r, sigma, T, M, K)
    delta_t = T/M;  //calculation of delta_t
    Beta = (exp(-r*delta_t)+exp((r+sigma^2)*delta_t))/2;  //calculation of beta for CRR
    u=Beta+sqrt((Beta^2)-1); //so u>d is true
    d=u^-1; //because ud=1
    q=(exp(r*delta_t)-d)/(u-d); //calculation of succes probability (u)
    S=zeros(M+1,M+1); //creation stock price matrix
    S(1,1)=S_0; //Setting stock price at t=0 as initial price in the stock matrix
     
    for i=2:M+1 //Initializing algo for computation of stock price 
        for j=1:i
            S(j,i)=S(1,1)*u^(j-1)*d^(i-j); //with j upwards and i-j downwards movements
        end
    end
    
    V=-ones(M+1,M+1); //creating option value matrix
    V(:,M+1)=max((K-S(:,M+1)), 0); //calculation of option values for last column
    
    for i=M:-1:1 //Initializing algo for computation of option price
        //for j=1:i (it is faster to use matrix operation than to include a second "for loop")
            //calculation of option values for rest of the matrix until V_0 
            V(1:i,i)=max(max((K-S(1:i,i)),0), exp(-r*delta_t)*(q*V(2:i+1,i+1)+(1-q)*V(1:i,i+1)));
        //end (not needed as second "for loop" is not used)
    end
    V_0 = V(1,1); //setting of first element of the option value matrix as option price at time t=0
endfunction

function V_0=CRR_AmPut_Adapt(S_0, r, sigma, T, K, M, epsilon)
//Calculation of Value price of an option for initial M and 2*M periods
// so the algorithms can be initialized
V_M = CRR_AmPut(S_0, r, sigma, T, M, K);
V_2M = CRR_AmPut(S_0, r, sigma, T, 2*M, K);

while abs(V_M-V_2M)/V_M>=epsilon //abs value procentual difference is compared
                                 //with given precision parameter "epsilon"
    V_M=V_2M;                    //
    M=2*M;
    V_2M = CRR_AmPut(S_0, r, sigma, T, 2*M, K);
end
V_0=V_2M;
endfunction
S_0=100; r=0.03; sigma=0.24; T=3/4; M=500, K=95; epsilon=0.001;
V_2M=CRR_AmPut_Adapt(S_0, r, sigma, T, K, M, epsilon);
disp("Option price at time t=0 for an American put option is "+string(CRR_AmPut(S_0, r, sigma, T, M, K)));
disp("Option price at time t=0 for an American put option is "+string(V_2M));
