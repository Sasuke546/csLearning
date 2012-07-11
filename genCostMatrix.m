function [cm] = genCostMatrix(t)

C = max(t);

cm = zeros(30,C,C);

for i = 1:30
    
    for j = 1:C
        for k = 1:C
            if j == k 
                cm(i,j,k) = 0;
            else
                cm(i,j,k) = round(rand*10);
                if cm(i,j,k) == 0
                    cm(i,j,k) = 1;
                end
            end
        end
    end
end

for i = 16:30
    
    for j = 1:C
        for k = 1:j-1
            cm(i,j,k) = cm(i,k,j);
        end
    end
end

end