function [ Rsm ] = get_Rsm_cost_svm_multiobj( C,Q,DS_train,DS_train_label,result_label,model,decision_values )

    [N,fea] = size(DS_train);
    K = size(C,1);
    table = zeros(1,N);
    flag = zeros(1,N); % mark, if table(x) has been calculate
    
    function I = get_stsm(x,result_x)
        
        if flag(1,x) == 1
            I = table(1,x);
            return;
        end
        
        gen_DS = gen_hset_new(fea,Q,0.01);
        DS_ran = zeros(100,fea);
        for i = 1:100
            for i2 = 1:fea-1
                DS_ran(i,i2) = DS_train(x,i2) + gen_DS(i2,i);
            end
        end
        
%         DS_ran_label = ones(100,1);
%         
%         %DS_ran_result = rbfnn_result(W,center_U,width_V,center_number,output_number,DS_ran);
%         [ans_label, acc, DS_ran_result ] = svmpredict(DS_ran_label,DS_ran, model);
%       
        [ans_label , DS_ran_result] = simlssvm(model,DS_ran);
        [ans,ans_label] = max(DS_ran_result,[],2);

%         DS_ran_result = decimal2vector(ans_label',K); % Temp for REMP
%         DS_ran_result = DS_ran_result';
%         
%         for i = 1:100
%             DS_ran_result(i,:) = (DS_ran_result(i,:) - result_x(1,:)).^2;
%         end
        
        I = mean(sum((DS_ran_result - repmat(result_x,100,1)).^2,1)/100);
        flag(1,x)=1;
        table(1,x)=I;
        
    end
 
    output = decimal2vector(DS_train_label',K) ;   % convert output_F to binary vector, column vector
    output = output';
    
%     decision_values = decimal2vector(result_label',K); % Temp for REMP
%     decision_values = decision_values';

     Rsm = zeros(1,2);
     
     for h = 1:K
         for j = 1:K
             
             if h==j
                 continue;
             end;
             
             mse = 0; stsm = 0;
             % for the sample of class h, it was classify to j, with Chj
             for s = 1:N
                 if DS_train_label(s,1)==h && result_label(s,1)==j
                     
                     mse = mse + (decision_values(s,:)-output(s,:)).^2;
                     
                     stsm = stsm + get_stsm(s,decision_values(s,:));
                     
                 end
             end
             
             Rsm(1,1) = Rsm(1,1) + C(h,j) * sqrt(mean(mse));
             Rsm(1,2) = Rsm(1,2) + C(h,j) * sqrt(mean(stsm));
             
         end
     end

end

