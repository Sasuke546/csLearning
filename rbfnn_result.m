function  result = rbfnn_result ( weight_W, center_U, width_V, center_number, output_number, test_dataset_TD)
% weight_W,center_U, width_V,center_number M, output_class: rbfnn structure
% test_dataset_TD: a colum for a test example
% result: a output_class*N matrix

[n,N] = size(test_dataset_TD) ; % N testing samples
pmh = zeros(center_number, N) ;
result = zeros(output_number, N) ;
test_dataset_TD(end,:) = [] ;
for i = 1:N
        temp =  repmat(test_dataset_TD(:,i),1, center_number) - center_U ;
        pmh(:,i) =exp( ( sum(temp.^2,1) ./  (-2*(width_V^2)) )' ) ;  % (-2*(width_V^2))
%   for j = 1:center_number
%                 pmh(j,i) = exp( pdist([test_dataset_TD(: ,i)' ; center_U(: ,j)'])^2 / ( -2*(width_V^2) ) ) ;   % pdist 计算两个行向量之间的欧氏距离(X-Uj)
%         end
end
result = weight_W * pmh ;
