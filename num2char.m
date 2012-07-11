function out = num2char(num)

out = '';
while num > 0
    out = strcat(out,'0'+ mod(num,10));
    num = fix(num/10);
end

t = '';
for i = size(out,2):-1:1
    t = strcat(t,out(1,i));
end

out = t;

end

