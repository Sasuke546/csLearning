function [c,x] = ga_cost_svm_lgem_matlab_multiobj( C,Q,t_l,t,te_l,te )
%GA_RSM_COST_SVM_MATLAB Summary of this function goes here
%   Detailed explanation goes 

t1 = cputime;

options = gaoptimset('PopulationType', 'bitstring','PopulationSize',10,'Generations',50,'TimeLimit',1800);

n = size(t,1)-1;

FitnessFCN = @(bit)ga_cost_svm_lgem_matlab_multiobj_fitness( bit,C,Q,t_l,t );

[x,fval,exitflag,output] = gamultiobj(FitnessFCN,n,[],[],[],[],[],[],options);

x = x(end,:);

train = t(find(x==1),:)';
train_label = t_l';
test = te(find(x==1),:)';
test_label = te_l';

model = initlssvm(train,train_label,'classification',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsAll');
model = trainlssvm(model);
[ans_label,dicision_value] = simlssvm(model,test);
[ans,ans_label] = max(dicision_value,[],2);

c = 0 ;
for i = 1:size(test,1)
    c = c + C(test_label(i,1),ans_label(i,1));
end

c;

%fprintf('program time is  ');

cputime - t1;

end

