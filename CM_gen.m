function [ CM ] = CM_gen(  )
%CM_GEN Summary of this function goes here
%   Detailed explanation goes here

CM = zeros(4,2,2);

for i = 1:4
    
    for j = 1:2
        
        for k = 1:2
            
            CM(i,j,k) = input('input!');
        end
    end
end

end

