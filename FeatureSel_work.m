% work of Feature selection of L-GEM based on RBFNN.

function [c]=FeatureSel_work(output_number, DS_train_file, DS_classNumber, Q_value, DS_test_file,ratio,C)

options = gaoptimset('PopulationType', 'bitstring');

n = size(DS_train_file,1)-1;

FitnessFCN = @(bit) LGEM_vector_FeatureSelection(bit,output_number, DS_train_file, DS_classNumber, Q_value, DS_test_file,ratio,C);

[x,fval,exitflag,output] = ga(FitnessFCN,n,options);

fval

x

train = DS_train_file(find(x==1),:);
train = [train;DS_train_file(end,:)];
test = DS_test_file(find(x==1),:);
test = [test;DS_test_file(end,:)];

[Rsm,test_mse,test_accu,center_U,tpr,tnr,tp_tn_avg,result,ind] = LGEM_vector(DS_classNumber, train, DS_classNumber, 0.001, test,1);

c = 0 ;
for i = 1:size(test,2)
    c = c + C(test(end,i),ind(1,i));
end

c

