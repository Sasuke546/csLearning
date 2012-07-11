function avg_Rsm = get_Rsm_vector (Q,center_U,width_V,weigth_W,training_sample_DS,output_number,neural_num_M,Remp_vector, A, kerci,uxi, var2, E1, E2)  % subfunction compute RQ
% kerci = B* sqrt(ln h / -2N) ; h = 0.025 page:7.
% calssify problem A = B = 1 ;
[n,N] = size(training_sample_DS) ;
for i = 1:output_number  % compute each output's RQ
        %compute sum vj and sum Lj
        for j = 1:neural_num_M
                vars(j) = sum(  E1 - var2 .^2 + 4*var2 .*( (uxi - center_U(:,j)).^2 ) + 4*E2 .* (uxi - center_U(:,j)) , 1 ) ;
              %  a=[1,1;1,1]
              %  b = E1-var2.^2
                %Es(j) = sum(var2 + ((uxi - center_U(:,j).^2)) ) ;
                Es(j) = sum(var2 + ( (uxi - center_U(:,j)).^2 ), 1 ) ; %%%%%%check! 
                fi(j) = weigth_W(i,j)^2 * exp( vars(j) / (2*(width_V^4)) - Es(j) / (width_V^2) ) ;
                target(j) = fi(j) / (width_V^4) ;
             %   target2_v(j) = fi(j) * ( sum(var2 + ( (uxi -
             %   center_U(:,j)).^2 ) / (width_V^4) ) )  ; %%%%%%%%%%%%%

                target2_v(j) = fi(j) * ( sum(var2 +  (uxi - center_U(:,j)).^2, 1 ) / width_V^4 )  ;          %changed by min
               
        end
      target2 =   sum(target2_v,2);
      target1 =     sum(target,2);
     sqrt_Remp  = sqrt(Remp_vector(i)) ;
     kerci;
     n;
     Q;
     Rsm(i) =( sqrt( 1/3 * Q^2 * sum(target2_v,2) + (0.2/9)* Q^4 * n * sum(target,2) )  +  sqrt(Remp_vector(i)) + A )^2 + kerci;  %%%% Remp is MSE(mean square error)
end
avg_Rsm = sum(Rsm) / length(Rsm) ; 


