function [method, result] = Simpson(x, y)
% Numerical Integration utilizing Simpson's Rule 
% 
% https://web.engr.oregonstate.edu/~webbky/MAE4020_5020_files/Section%208%20Integration.pdf

    narginchk(2,2)              % check # of input arguments

    Nseg = length(y) - 1;
    dx = ( max(x) - min(x) )/( length(x) - 1 );     % x-spacing

    if mod(Nseg, 2) == 0        % Simpson's 1/3 rule: number of segments must be even
        method = 'Simpson''s 1/3 Rule';
        sumOdd = 0;     % sum over odd segments
        for i=1:2:Nseg-1
            sumOdd = sumOdd + y(i+1);
        end
        sumEven = 0;    % sum over even segments
        for i=2:2:Nseg-2
            sumEven = sumEven + y(i+1);
        end
        result = 1/3*dx*(y(1) + 4*sumOdd + 2*sumEven + y(Nseg+1));

    elseif mod(Nseg, 3) == 0    %  Simpson's 3/8 rule: number of segments must be divisible by 3
        method = 'Simpson''s 3/8 Rule';
        sum1 = 0;     
        for i=1:3:Nseg-2
            sum1 = sum1+ y(i+1);
        end
        sum2= 0;   
        for i=2:3:Nseg-1
            sum2 = sum2 + y(i+1);
        end
        sum3= 0;   
        for i=3:3:Nseg-3
            sum3 = sum3 + y(i+1);
        end
        result = 3/8*dx*(y(1) + 3*sum1 + 3*sum2 + 2*sum3 + y(Nseg+1));

    else                        % default to trapezoidal rule
        method = 'Trapezoidal Rule';
        result = trapz(x, y);
    end
end