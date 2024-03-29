function [y] = LGEM_vector_FeatureSelection(bit,output_number, DS_train_file, DS_classNumber, Q_value, DS_test_file,ratio,C)
% compute Rsm(Q)
% output_number: the number of output nodes ;
% DS_train :training dataset, each col for samples ;
% calssifier problem A = B =1 ;

% data set process

numFea = size(bit,2);
n = size(find(bit==1),2);
if n==0 y=9999; return; end; 
[sourceFea,N] = size(DS_train_file);
DS_train = zeros(n,N);
N1 = size(DS_test_file,2);
DS_test = zeros(n,N1);

n = 1;
for i = 1:numFea
    if bit(1,i) == 1
        DS_train(n,:) = DS_train_file(i,:);
        DS_test(n,:) = DS_test_file(i,:);
        n = n + 1;
    end
end

DS_train(n,:) = DS_train_file(sourceFea,:);
DS_test(n,:) = DS_test_file(sourceFea,:);

%DS_train = load(DS_train_file);
%DS_train = DS_train_file;
%DS_test = load(DS_test_file);
%DS_test = DS_test_file;
A = 1 ;
B = 1 ;  %the maximum possible value of the MSE                               ？？
cigma = 0.025 ; %论文第三页的η                                                ？？    
% % % % % % % % % %first: remove the class type row. % % % % % % % % % % %
training_sample_DS = DS_train ;
training_sample_DS(end,:) = [] ;
[n,N] = size(training_sample_DS) ;

testing_sample_DS = DS_test ;
testing_sample_DS(end,:) = [] ;
[n1,N1] = size(testing_sample_DS) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%These value is not change
% compute each feature's mean value uxi
uxi = (mean(training_sample_DS,2)) ;
% compute each feature's var value
var2 = mean( (training_sample_DS - repmat(uxi,1,N) ).^2 , 2 ) ;   

E1 = mean( (training_sample_DS-repmat(uxi,1,N) ).^4 ,2) ;       % E1
E2 = mean( (training_sample_DS-repmat(uxi,1,N) ).^3 ,2) ;       % E2
kerci = B * sqrt(log(cigma) / (-2*N)) ;   % attention: N is the training samples number       kerci：第三页的ε
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%These value is not change

k = DS_classNumber ;
Rsm = zeros(1,N-k+1) ;    % initialize RQ to store the Rsm
Rsm_Raccu = zeros(1,N-k+1) ; 
test_accu =  zeros(1,N-k+1) ;
test_mse =  zeros(1,N-k+1) ;
tpr =  zeros(1,N-k+1) ;
tnr =  zeros(1,N-k+1) ;
tp_tn_avg =  zeros(1,N-k+1) ;
hidden_max = N * 0.25;
start = DS_classNumber;
endt = hidden_max;
for z = start:1:endt
        z;
        center_U = k_means_01(z, DS_train, DS_classNumber);% k-means for z center 
        %save center_U;
        %save width_V;
        
        width_V = width_Mean(center_U) ;
        if width_V ==0
            continue;
        end
        width_V = width_V * ratio;
        weigth_W = rbfnn_weight(center_U,width_V, DS_train,output_number); % training rbfnn
        result = rbfnn_result(weigth_W, center_U, width_V,z,output_number,DS_train);

        % compute empirical risk, the reurn Remp is a MSE(mean square error)
        Remp_vector =rbfnn_MSE(DS_train, weigth_W, center_U, width_V, z ,output_number); % The return value Remp_vector is a vector format
        
        %Rsm_Raccu(z-k+1) = rbfnn_Accuracy(DS_train, weigth_W, center_U, width_V, z ,output_number) ;
        % % R_accuracy      
        test_mse(z-k+1) = mean(Remp_vector);
        [test_accu(z-k+1),tpr(z),tnr(z),tp_tn_avg(z)] = rbfnn_Accuracy(DS_test, weigth_W, center_U, width_V, z,output_number) ;
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
       
       %Rsm(z-k+1) = get_Rsm_vector( Q_value, center_U, width_V,weigth_W,training_sample_DS,output_number, z ,Remp_vector, A, kerci,uxi, var2, E1, E2) ; % function call
       Rsm(z-k+1) = get_Rsm_cost( C,Q_value, weigth_W, center_U, width_V,z,DS_train,output_number,result );

end  %%end for z=k:num

min_Rsm = min(Rsm(start-k+1:endt-k+1)) ;

% min_index = find( Rsm(start-k+1:endt-k+1) == min_Rsm );
% 
% center_number=min_index-1+start;
% %center_number=round(N*0.25);
% 
% center_U = k_means_01(center_number, DS_train, DS_classNumber) ;
% width_V = width_Mean(center_U); %
%     bit;
%   width_V; 
% W = rbfnn_weight(center_U,width_V, DS_train,output_number);
% 
% result = rbfnn_result(W, center_U, width_V,center_number,output_number,DS_train);

y = min_Rsm;

%y = get_Rsm_cost( C,Q_value,W, center_U, width_V,center_number,DS_train,output_number,result );

% [mx,ind] = max(result);
% num = 0;
% for i=1:N1
%     if ind(1,i)==DS_train(n1+1,i)
%         num = num +1;
%     end
% end
% 
% num/N1

end