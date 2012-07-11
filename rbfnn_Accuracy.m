% function Accu = rbfnn_Accuracy(dataset_TD, weight_W, center_U, width_V, center_number,output_number)
% % compute testing and training accuracy
% % dataset_TD: dataset, it conclude the class type
% % RBFNN structure:      weight_W, center_U, width_V,
% %                                    center_number,output_number
% 
% output_F =  dataset_TD(end,:) ;   
% output = decimal2vector(output_F,output_number) ;   % convert output_F to binary vector, column vector
% result = rbfnn_result ( weight_W, center_U, width_V, center_number, output_number, dataset_TD) ;
% cout = 0 ;
% [M, N] = size(output) ;
% for i = 1:N
%         for j = 1:M
%             if result(j,i)<0.5
%                 result_bin(j,i) = 0;
%             else
%                 result_bin(j,i) = 1;
%             end
%         end
%         if output(:,i) == result_bin(:,i) 
%                 cout = cout + 1 ;
%         end
% end
% Accu = cout / N ;


function  [Accu,tpr,tnr,avg] = rbfnn_Accuracy(dataset_TD, weight_W, center_U, width_V, center_number,output_number)
% compute testing and training accuracy
% dataset_TD: dataset, it conclude the class type
% RBFNN structure:      weight_W, center_U, width_V,
%                                    center_number,output_number
output_F =  dataset_TD(end,:) ; 
output = decimal2vector(output_F,output_number);    % convert output_F to binary vector, column vector
result = rbfnn_result ( weight_W, center_U, width_V, center_number, output_number, dataset_TD) ;
tp = 0;
tn = 0;
[M, N] = size(output);
for i = 1:N
        for j = 1:M
            if result(j,i)<0.5
                result_bin(j,i) = 0;
            else
                result_bin(j,i) = 1;
            end
        end
        if result_bin(:,i) == 1
            if output(:,i) == 1
                tp = tp +1;
            end
        end
        if result_bin(:,i) == 0
            if output(:,i) == 0
                tn = tn + 1;
            end
        end        
end
p_num = 0;
n_num = 0;
for k=1:N
    if output(1,k) == 1
        p_num = p_num + 1;
    end
    if output(1,k) == 0
        n_num = n_num +1;
    end
end  
Accu = (tp+tn) / N ;
tpr = tp / p_num;
tnr = tn / n_num;
avg = (tpr+tnr)/2;