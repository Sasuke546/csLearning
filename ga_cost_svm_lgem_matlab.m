function [c,x] = ga_cost_svm_lgem_matlab( C,Q,t_l,t,te_l,te )
%GA_RSM_COST_SVM_MATLAB Summary of this function goes here
%   Detailed explanation goes 

%t1 = cputime;

options = gaoptimset('PopulationType', 'bitstring','PopulationSize',20,'Generations',50,'TimeLimit',3600);

n = size(t,1)-1;
    
FitnessFCN = @(bit)ga_cost_svm_lgem_matlab_fitness( bit,C,Q,t_l,t );

[x,fval,exitflag,output] = ga(FitnessFCN,n,options);


x

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

c

%cputime - t1

end

