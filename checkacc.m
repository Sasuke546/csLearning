function [ acc ] = checkacc( a,b )
%CHECKACC Summary of this function goes here
%   Detailed explanation goes here

N = size(a,1);

acc = 0;
for i = 1:N
    if a(i,1) == b(i,1)
        acc = acc + 1;
    end
end

acc = acc / N;


end




% for i = 1:8
%     x = 0;
%     for j = 1:30
%         x = x+lib(i,j,2);
%     end
%     ans(i) = x/30.0;
% 
%     x = 0;
%     for j=1:30;
%         x = x+ls(i,j,2);
%     end
%     ans2(i) = x/30.0;
% end
