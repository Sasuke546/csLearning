
fid = fopen('btest\\hepatitis.txt','r');



in = fscanf(fid,'%d');


i=1;

% for index = 1:30

%     s = sprintf('load hepatitis\\hepatitis_%d.mat;',index);
%     eval(s);

n = size(Train_current_DS,1)-1;

x = zeros(1,n);
i = i+1;
for j = 1:n
    x(1,j) = in(i,1);
    i = i+1;
end

train = Train_current_DS(find(x==1),:)';
train_label = Train_FX';
test = Test_current_DS(find(x==1),:)';
test_label = Test_FX';

model = initlssvm(train,train_label,'classification',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsAll');
model = trainlssvm(model);
[ans_label,dicision_value] = simlssvm(model,test);

cost_label = ans_label;

c12=0;
c21=0;
for j = 1:size(Test_FX,2)
    if test_label(j,1)==1 && ans_label(j,1)==2
        c12 = c12+1;
    end
    if test_label(j,1)==2 && ans_label(j,1)==1
        c21 = c21+1;
    end
end

checkacc(ans_label,test_label)

train = Train_current_DS(1:end-1,:)';
test = Test_current_DS(1:end-1,:)';

model = initlssvm(train,train_label,'classification',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsAll');
model = trainlssvm(model);
[ans_label,dicision_value] = simlssvm(model,test);

checkacc(ans_label,test_label)

cost_label(:,2) = ans_label;
cost_label(:,3) = test_label;
    
% end

c12
c21

fclose(fid);