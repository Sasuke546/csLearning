function show(cm)

len = size(cm,1);
K = size(cm,2);

for i = 1:len
for j = 1:K
for k = 1:K
fprintf('%d ',cm(i,j,k));
end
fprintf('\n');
end
fprintf('\n');
end

end