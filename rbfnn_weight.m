function W = rbfnn_weight(center_U,width_V,training_DS,output_number)
% training rbfnn
% center_U for center, width_V for width, DS for training Dataset
% training_DS: each col for a training sample, it include the class type(the last member of cols)
% output_F: each col for a output
% width_V: a cell type contain the width
% center_U: a cell type contain the centers
[n1,sample_num] = size(training_DS) ;  % sample_num 为训练样本个数 , n1 denotes the features number, the last deminsion is class type

% %% Attention : extract output class from training samples
%%% output_F: each member of output_F is not a vector, it need to trainsform each member to a col vector  
output_F =  training_DS(n1,:) ;
%%%%% convert decimal output to binary output .%%%%%
output_bin = decimal2vector(output_F,output_number) ;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
training_DS(n1,:) = [] ;   % remove the larst row —— class type row
[n1,samples_num] = size(training_DS) ;

[n,M] = size(center_U) ;  %% M denotes the hiddern neurals number(or centers number)

if n ~= n1     % 检查样本的特征数是否与中心的相同
    error('the number of features in centers are different with training samples! please chek!')
end

pmh = zeros(M,sample_num) ; % pmh 保存训练样本计算所得到的基函数值矩阵pinv(pmh)
for i = 1:sample_num   %计算pmh
       temp =  repmat(training_DS(:,i),1,M) - center_U ;
    %   a =  sum(temp.^2)
%       a = exp( ( sum(temp.^2) ./  (-2*(width_V^2)) )' )
       pmh(:,i) =exp( ( sum(temp.^2,1) ./  (-2*(width_V^2)) )' );   % (-2*(width_V^2))
end
% pmh = pmh + eye(size(pmh))*0.0001;   %%% attention
pmh = pmh + eye(size(pmh))*0.0001;   %%% attentio

tt = isnan(pmh);
    
for ii = 1:size(pmh,1)
    for jj = 1:size(pmh,2)
        if(tt(ii,jj)==1)
            pmh(ii,jj) = 999999999;
        end
    end
end

tt = isinf(pmh);

for ii = 1:size(pmh,1)
    for jj = 1:size(pmh,2)
        if(tt(ii,jj)==1)
            pmh(ii,jj) = 999999999;
        end
    end
end

    
W = output_bin * pinv(pmh) ;
        