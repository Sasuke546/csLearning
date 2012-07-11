function width_V = width_Mean(center_U)
% center_U is get by k_means2 function, its a cell matrix
% width_V is also a cell matrix

%%%%%%%convert cell type to a matrix U
[n,M] = size(center_U) ;
cout = 1 ;
for j = 1:M
        for k = j+1:M
                distance =  norm(center_U(:,j) - center_U(:,k)) ;
                vector_d(cout) = distance ;
                cout = cout +1 ;
        end
end
mean_distance = sum(vector_d)/length(vector_d) ;
width_V = mean_distance ;