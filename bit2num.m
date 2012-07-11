function [ x ] = bit2num( bit )

t=1;x=0;

for i=1:length(bit)
    
    x = x + bit(1,i)*t;
    
    t = t*2;
end

end

