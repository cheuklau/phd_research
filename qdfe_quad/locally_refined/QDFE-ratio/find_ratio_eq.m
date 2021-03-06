% Find side and corner ratios minimizing residual
function [x, res_x] = find_ratio_eq(...
    subSubLengthX, subSubLengthY, ...
    minSubSubX, maxSubSubX, ...
    minSubSubY, maxSubSubY, ...
    integrations, surfaceArea)

% Iteration parameters
tol       = 1e-15;
maxCounts = 1000;

% Initial range
a = 0.3;
b = 0.7;
c = 0.9;

% Residuals for range
res_a = calc_res(...
    a, a, ...
    subSubLengthX, subSubLengthY, ...
    minSubSubX, maxSubSubX, ...
    minSubSubY, maxSubSubY, ...
    integrations, surfaceArea);
res_b = calc_res(...
    b, b, ...
    subSubLengthX, subSubLengthY, ...
    minSubSubX, maxSubSubX, ...
    minSubSubY, maxSubSubY, ...
    integrations, surfaceArea);
res_c = calc_res(...
    c, c, ...
    subSubLengthX, subSubLengthY, ...
    minSubSubX, maxSubSubX, ...
    minSubSubY, maxSubSubY, ...
    integrations, surfaceArea);

% Check if the minimum is bounded
if abs(res_b) >= abs(res_a) || abs(res_b) >= abs(res_c)
    error('bounds for finding minimum residual are wrong');
end

% Start iteration
delta     = abs(c - a);
counter   = 1;
converged = 0;
while delta > tol && counter < maxCounts && converged == 0
    
    % New search ratio and residual
    x = (b + c) / 2;
    res_x = calc_res(...
        x, x, ...
        subSubLengthX, subSubLengthY, ...
        minSubSubX, maxSubSubX, ...
        minSubSubY, maxSubSubY, ...
        integrations, surfaceArea);
    
    % Determine new bounds
    if abs(res_b) < abs(res_x)
        
        c = x;
                
    elseif abs(res_b) > abs(res_x)
        
        a = b;
                
    elseif abs(res_b) == abs(res_x)                
        
        converged = 1;
        
    end
    
    % Calculate new mid-point
    b = (c + a) / 2;
    
    % Calculate new residual
    res_b = calc_res(...
        b, b, ...
        subSubLengthX, subSubLengthY, ...
        minSubSubX, maxSubSubX, ...
        minSubSubY, maxSubSubY, ...
        integrations, surfaceArea);
    
    % Calculate new delta
    delta = abs(c - a);
    
    % Update counter
    counter = counter + 1;
    
end

end