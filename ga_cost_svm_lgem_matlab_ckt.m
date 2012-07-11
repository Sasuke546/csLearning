function [acc,x] = ga_cost_svm_lgem_matlab_ckt( C,Q,t_l,t,te_l,te,gen_DS,type )
%GA_RSM_COST_SVM_MATLAB Summary of this function goes here
%   Detailed explanation goes 

%t1 = cputime;

options = gaoptimset('PopulationType', 'bitstring','PopulationSize',20,'Generations',50,'TimeLimit',3600);

n = size(t,1)-1;

% global checktable
% global table
% 
% checktable = zeros(1,2.^n);
% table = zeros(1,2.^n);

% for 2 class problem the label

model = initlssvm(t(end-1,:)',t_l','classification',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsAll');
    
FitnessFCN = @(bit)ga_cost_svm_lgem_matlab_fitness_ckt( bit,C,Q,t_l,t,model,gen_DS,type );

[x,fval,exitflag,output] = ga(FitnessFCN,n,options);

train = t(find(x==1),:)';
train_label = t_l';
test = te(find(x==1),:)';
test_label = te_l';

nt = size(train,1);

tr = train; trla = train_label;

s = 1:nt;

c = 999999999;

for itr = 1:nt/2
    
try
    tr = train(s,:);
    trla = train_label(s,:);
    
    model = initlssvm(tr,trla,'classification',[],[],'RBF_kernel');
    model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsOne');
    model = trainlssvm(model);
    [ans_label,dicision_value] = simlssvm(model,test);
    
    acc = size(find(ans_label==test_label),1)/size(test_label,1);

    tc = 0 ;
    for i = 1:size(test,1)
        tc = tc + C(test_label(i,1),ans_label(i,1));
    end
    
    c = min(c,tc);    
    
    [a_min,f] = min(abs(model.alpha));
    ind = [1:f-1,f+1:length(s)];
    s = s(ind);
catch ME 
    break;
end

end

