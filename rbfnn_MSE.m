function MSE = rbfnn_MSE(dataset_TD, weight_W, center_U, width_V, center_number, output_number)
% compute Remp mean square error(MSE)
% The return Remp is a real value
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

output_F =  dataset_TD(end,:) ;   
output = decimal2vector(output_F,output_number) ;   % convert output_F to binary vector, column vector
result = rbfnn_result ( weight_W, center_U, width_V, center_number, output_number, dataset_TD) ;

%MSE = sum((output - result).^2, 2) ; % sum each row
MSE = mean((output - result).^2, 2) ; %changed by min 