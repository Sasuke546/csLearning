function [ Rsm ] = get_Rsm_cost_multiobj( C,Q,W, center_U, width_V,center_number,DS_train,output_number,result )

    [fea,N] = size(DS_train);
    K = size(C,1);
    table = zeros(1,N);
    flag = zeros(1,N); % mark, if table(x) has been calculate
    
    function I = get_stsm(x,result_x)
        
        if flag(1,x) == 1
            I = table(1,x);
            return;
        end
        
        gen_DS = gen_hset_new(fea-1,Q,0.01);
        DS_ran = zeros(fea,100);
        for i = 1:100
            for i2 = 1:fea-1
                DS_ran(i2,i) = DS_train(i2,x) + gen_DS(i2,i);
            end
        end
        DS_ran_result = rbfnn_result(W,center_U,width_V,center_number,output_number,DS_ran);
        
        for i = 1:100
            DS_ran_result(:,i) = (DS_ran_result(:,i) - result_x(:,1)).^2;
        end
        
        I = mean(sum((DS_ran_result - repmat(result_x,1,100)).^2,2)/100);
        flag(1,x)=1;
        table(1,x)=I;
        
    end

     output_F =  DS_train(end,:) ;   
     output = decimal2vector(output_F,output_number) ;   % convert output_F to binary vector, column vector
     
     
     [mx,ind] = max(result);
     Rsm = zeros(1,2);
     
     for h = 1:K
         for j = 1:K
             
             if h==j
                 continue;
             end;
             
             mse = 0; stsm = 0;
             % for the sample of class h, it was classify to j, with Chj
             for s = 1:N
                 if output_F(1,s)==h && ind(1,s)==j
                     
                     mse = mse + (output(:,s)-result(:,s)).^2;
                     
                     stsm = stsm + get_stsm(s,result(:,s));
                     
                 end
             end
             
             Rsm(1,1) = Rsm(1,1) + C(h,j) * sqrt(mean(mse));
             Rsm(1,2) = Rsm(1,2) + C(h,j) * sqrt(mean(stsm));
             
         end
     end

end


