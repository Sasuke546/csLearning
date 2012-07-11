t = Train_current_DS(1:end-1,:)';
te = Test_current_DS(1:end-1,:)';
t_l = Train_FX';
te_l = Test_FX';

% model = initlssvm(t,t_l,'classifier',[],[],'RBF_kernel');
% model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsOne');
% % model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'});
% model = trainlssvm(model);
% [ans_label,dicision_value] = simlssvm(model,te);
type = 'classification';
kernel = 'RBF_kernel';

X=t;Y=t_l;
%[gam, sig2] = bay_initlssvm({X, Y, type, [], [], kernel, 'original'});
model = initlssvm(t,t_l,'classifier',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'});
model = trainlssvm(model);
model.implementation = 'MATLAB';
[model, alpha, b] = bay_optimize(model, 1);
[model, gam_opt] = bay_optimize(model,2);
[cost_L3,sig2_opt] = bay_optimize(model,3);

model.gam = gam_opt;
model.kernel_pars = sig2_opt;

testOutputY = simlssvm( model, te);
%testOutputY = bay_modoutClass({X,Y,type,gam_opt,sig2_opt,'RBF_kernel'},te);
bayAcc_lssvm = size( find (testOutputY == te_l ), 1) / size(te,1)


% [gam, sig2] = bay_initlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% [model, gam_opt] = bay_optimize({X,Y,type,gam,sig2,'RBF_kernel'},2);
% [cost_L3,sig2_opt] = bay_optimize({X,Y,type,gam_opt,sig2,'RBF_kernel'},3);
% Ymodout = bay_modoutClass({X,Y,type,gam_opt,sig2_opt,'RBF_kernel'},te);
% bayAcc_lssvm = size( find (Ymodout == te_l ), 1) / size(te,1)

%% original method

model = initlssvm(t,t_l,'classifier',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'});
model = trainlssvm(model);
[ans_label,dicision_value] = simlssvm(model,te);

bayAcc_lssvm = size( find (ans_label == te_l ), 1) / size(te,1)
%%

% % x = [0,1,1,0,1,0,0,0,0,1,1,1,1,0,1,1,0,1,0;];
% 
% %x = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;];
% 
% ls = zeros(8,30,2);
% lib = zeros(8,30,2);
% 
% for ma = 1:8
% for index = 1:30
% 
%     s = sprintf('load breast\\breast_%d.mat;',index);
%     eval(s);
%     s = sprintf('K=max(Train_FX);');
%     %s = sprintf('K=max(Train_FX);CostMatrix=round(rand(K,K)*10);for kk=1:K CostMatrix(kk,kk)=0; end');
%     eval(s);
%     
%     C = zeros(K,K);
%     for j = 1:K
%         for k = 1:K
%             C(j,k) = CostMatrix(ma,j,k);
%         end
%     end
%     
% t = Train_current_DS';
% te = Test_current_DS';
% t_l = Train_FX';
% te_l = Test_FX';
% 
% % for i = 1:size(t_l,2)
% %     if t_l(1,i) == 2
% %         t_l(1,i) = -1;
% %     end
% % end
% % 
% % for i = 1:size(te_l,2)
% %     if te_l(1,i) == 2
% %         te_l(1,i) = -1;
% %     end
% % end
% 
% model =  svmtrain(t_l, t);
% [ans_label, acc, dicision_value ] = svmpredict(te_l,te,model);
% lib(ma,index,1) = checkacc(ans_label,te_l);
% 
% c=0;
% for i = 1:size(te,1)
%     c = c + C(te_l(i,1),ans_label(i,1));
% end
% lib(ma,index,2)=c;
% 
% %         
% % train = t(find(x==1),:)';
% % train_label = t_l';
% % test = te(find(x==1),:)';
% % test_label = te_l';
% 
% model = initlssvm(t,t_l,'classifier',[],[],'RBF_kernel');
% model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'},'code_OneVsOne');
% % model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'misclass'});
% model = trainlssvm(model);
% [ans_label,dicision_value] = simlssvm(model,te);
% if max(t_l)>2    % if class is 2 , the decision vecotr only has 1 value. (-1 or 1)
%         [ans,ans_label] = max(dicision_value,[],2);
% end
% %ans_label= simlssvm(model,test);
% %[ans,ans_label] = max(dicision_value,[],2);
% 
% ls(ma,index,1) = checkacc(ans_label,te_l);
% 
% c = 0 ;
% for i = 1:size(te,1)
%     c = c + C(te_l(i,1),ans_label(i,1));
% end
% 
% ls(ma,index,2)= c;
% 
% ans_label = zeros(size(te_l,1),1);
% 
% end
% end
% 
% fid = fopen('test.txt','w+');
% 
% x = [0 0 1 1 1 ];
% 
% fprintf(fid,'%d ',x);
% 
% fclose(fid);
