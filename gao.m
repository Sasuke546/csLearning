FinalResult=zeros(30,3);
Time = zeros(30,3);
feature1 = zeros(30,size(Train_current_DS,1)-1);
feature2 = zeros(30,size(Train_current_DS,1)-1);

for times = 1:1
for index = 1:30

    s = sprintf('load yeast\\yeast_%d.mat;',index);
    eval(s);
    s = sprintf('K=max(Train_FX);');
    %s = sprintf('K=max(Train_FX);CostMatrix=round(rand(K,K)*10);for kk=1:K CostMatrix(kk,kk)=0; end');
    eval(s);
    
    CostMatrix = zeros(K,K);
    for j = 1:K
        for k = 1:K
            CostMatrix(j,k) = Cost_yeast(index,j,k);
        end
    end

%% pairwise

t1 = cputime;

NQ=size(Train_current_DS,1);
rstart=7;iter=5000;step=1.0;N=100;targ=1;Ctest=CostMatrix;Wstart=0.00001.*rand(K,NQ);ro=-0.9;
Classification_to_K_Classes_2CostF_l

FinalResult(index,1) = cost;
Time(index,1) = cputime - t1;

%% Proposed methodology

%FinalResult(index,2) = FeatureSel_work(K, Train_current_DS, K, 0.001, Test_current_DS,1,CostMatrix);

%FinalResult(index,2) = FeatureSel_Multiobj(K, Train_current_DS, K, 0.001, Test_current_DS,1,CostMatrix);

%% Proposed svm

% t1 = cputime;
% 
% [A,feature1(index,:)] = ga_cost_svm_lgem_matlab(CostMatrix,0.001,Train_FX,Train_current_DS,Test_FX,Test_current_DS);
% FinalResult(index,2) = FinalResult(index,2) + A;
% Time(index,2) = cputime - t1;
% 
% t1 = cputime;
% 
% [A,feature2(index,:)] = ga_cost_svm_lgem_matlab_multiobj(CostMatrix,0.001,Train_FX,Train_current_DS,Test_FX,Test_current_DS);
% FinalResult(index,3) = FinalResult(index,3) + A;
% Time(index,3) = cputime - t1;

end;
end;