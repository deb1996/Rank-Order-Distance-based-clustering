function [d] = cveculidean( X,Y )
V = ~isnan(X); X(~V) = 0; % V = ones(D, N); 
U = ~isnan(Y); Y(~U) = 0; % U = ones(D, P); 
d = abs(X'.^2*U - 2*X'*Y + V'*Y.^2);
end

