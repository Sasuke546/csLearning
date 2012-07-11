% yeast vote tic_tac_toe sonar pima liver hepatitis heart ecoli card breast

file = str2mat('breast','hepatitis','pima','card','sonar','ionos');

for fileID = 1:2
    
    writefile = strcat(file(fileID,:),'.txt');
    fid = fopen(writefile,'w+');

    load CostMatrix.mat;
    load gen_DS.mat;

    for costId = 1:size(CostMatrix,1)
        for index = 1:2
            
            filename = strcat(file(fileID,:),'\\',file(fileID,:),'_',num2char(index),'.mat');
            load(filename);
            
            K = size(CostMatrix,2);

            CM = zeros(K,K);
            for j = 1:K
                for k = 1:K
                    CM(j,k) = CostMatrix(costId,j,k);
                end
            end

        %% pairwise

        NQ=size(Train_current_DS,1);
        rstart=7;iter=5000;step=1.0;N=100;targ=1;Ctest=CM;Wstart=0.00001.*rand(K,NQ);ro=-0.9;
        Classification_to_K_Classes_2CostF_l

        fprintf(fid,'%d\n',cost);

        %% Proposed methodology

        %% Proposed svm

    %     global checktable
    %     global table
    %     global ta_acc

%         [c,x] = ga_cost_svm_lgem_matlab_ckt(CM,0.001,Train_FX,Train_current_DS,Test_FX,Test_current_DS,gen_DS,1);
% 
%         fprintf(fid,'%d\n',c);
%         fprintf(fid,'%d ',x);
%         fprintf(fid,'\n');
        
        [c,x] = ga_cost_svm_lgem_matlab_ckt(CM,0.001,Train_FX,Train_current_DS,Test_FX,Test_current_DS,gen_DS,2);

        fprintf(fid,'%d\n',c);
        fprintf(fid,'%d ',x);
        fprintf(fid,'\n');

        % [A,feature2(index,:)] = ga_cost_svm_lgem_matlab_multiobj_ckt(CostMatrix,0.001,Train_FX,Train_current_DS,Test_FX,Test_current_DS);
        % FinalResult(index,3) = FinalResult(index,3) + A;
        % Time(index,3) = cputime - t1;

        end;
    end;

    fclose(fid);

end