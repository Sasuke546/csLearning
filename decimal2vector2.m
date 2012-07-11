function [ x ] = decimal2vector2( x )

% x = [ 1 1 1 2 2 2 .... ;]; change class 2 to -1

for i = 1:size(x,2)
    if ( x(i) == 2 )
        x(i) = -1;
    end
end


end

