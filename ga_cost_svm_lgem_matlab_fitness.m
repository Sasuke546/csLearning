function [ y ] = ga_cost_svm_lgem_matlab_fitness( chr,C,Q,t_l,t )

% if length(chr) <20
%     
%     if checktable(1,bit2num(chr))==1
%         y = table(1,bit2num(chr));
%         return;
%     end
% end

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
    y = 999999999;
else
%     model =  svmtrain(t_l', DS_train');
%     [ans_label, acc, dicision_value ] = svmpredict(t_l',DS_train', model);
    model = initlssvm(DS_train',t_l','classification',[],[],'RBF_kernel');
    model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsAll');
    model = trainlssvm(model);
    [ans_label,dicision_value] = simlssvm(model,DS_train');
    [ans,ans_label] = max(dicision_value,[],2);
    y = get_Rsm_cost_svm(C,Q,DS_train',t_l',ans_label,model,dicision_value);
end

% if length(chr) <20
%     
%     checktable(1,bit2num(chr))=1;
%     table(1,bit2num(chr)) =y;
%  
% end


end

