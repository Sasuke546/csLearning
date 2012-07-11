function [ y ] = ga_cost_svm_lgem_matlab_multiobj_fitness( chr,C,Q,t_l,t )

n = 1;

numFea = size(find(chr==1),2);

DS_train = zeros(numFea,size(t,2));

for i = 1:size(chr,2)
    if chr(1,i) == 1
        DS_train(n,:) = t(i,:);
        n = n + 1;
    end
end

if n == 1
    y = [999999999;999999999];
else
    model = initlssvm(DS_train',t_l','classification',[],[],'RBF_kernel');
    model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsAll');
    model = trainlssvm(model);
    [ans_label,dicision_value] = simlssvm(model,DS_train');
    [ans,ans_label] = max(dicision_value,[],2);
    y = get_Rsm_cost_svm_multiobj(C,Q,DS_train',t_l',ans_label,model,dicision_value);
end


end