% fitness function of the GA in the feature selection L-GEM

function [ y ] = FeatureSelection_Fitness( Feature_Bitstring )

    [y,Rsm,test_mse,test_accu,center_U,tpr,tnr,tp_tn_avg,result,ind] = LGEM_vector_FeatureSelection(bit,output_number, DS_train_file, DS_classNumber, Q_value, DS_test_file,ratio)



end

