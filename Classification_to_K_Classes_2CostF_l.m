%clear;rstart=7;iter=5000;step=1.0;N=100;K=4;targ=1;Ctest=1-eye(K);Wstart=0.00001.*rand(K,3);ro=-0.9;Classification_to_K_Classes_2CostF
% Testining the novel cost function aimed to discriminate K pattern classes
% paying a speciall attention to pairwise classification errors
 % Author Sarunas Raudys, sarunas.raudys@mif.vu.lt
sp=['--k.r.b.g.'];spO=['--korsbdgh'];rand('seed',932*rstart^3+rstart*1003061);randn('seed',19*rstart^4+rstart*6703631); % set random number generator

%labSLP=reshape(ones(N,K)*diag([1;2;3;4]),K*N,1); %determining the labels (class numbers)
m1=2;m2=2;co=0.5*[1,ro;ro,1];m=[m1,m2;m1+0.8,-m2+0.6;-m1-0.8,m2-0.6;-m1,-m2];% set parameters of the 2-dimensional Gaussian data
%figure(1);clf;hold on;figure(2);clf;hold on;

%XMOK=[];for j=1:K G=gausas(N,co,m(j,:));XMOK=[XMOK;G]; end %figure(1);plot(G(:,1),G(:,2),sp(j*2+[1:2]));figure(2);plot(G(:,1),G(:,2),sp(j*2+[1:2]));end % K class data generation and 2-dimensional display

%data import , change the form of the data set 

%load('heart_9.mat');

[n1,m1] = size(Train_current_DS); % n1 , number of the feature +1 , m1, number of the sample
[m2] = size(Test_current_DS,2);
XMOK = zeros(m1,n1-1); %Train set
XMOKT = zeros(m2,n1-1); % Test set
for i = 1:m1
    XMOK(i,1:n1-1) = Train_current_DS(1:n1-1,i)';
end
for i = 1:m2
    XMOKT(i,1:n1-1) = Test_current_DS(1:n1-1,i)';
end
labSLP = zeros(m1,1);
labSLPT = zeros(m2,1);
labSLP(1:m1,1) = Train_current_DS(n1,1:m1)'; %Train set label
labSLPT(1:m2,1) = Test_current_DS(n1,1:m2)'; %Test set label

% Ctest = rand(K,K);
% for i = 1:K
%     Ctest(i,i)=0;
% end
% row 32 and row 36 : zeros(K,3) was modified to zeros(K,n1) 

Om=ones(m1,1); Ot=ones(m2,1); Ov=ones(m1*10,1);Nnoise=10;k_NN=2;sd_noise=0.5;r0=K+1;AlFa=0.1;LL=0.01;

MM=mean(XMOK);sdev=std(XMOK);XMOK=(XMOK-Om*MM)./(Om*sdev);XMOKT=(XMOKT-Ot*MM)./(Ot*sdev);%Data normalization aero mean and unit - variance
YVal=[];labpv=[];
for j=1:K 
    GGG=find(labSLP==j);
    UUU=ColorGAUSnoise(XMOK(GGG,:),k_NN,Nnoise,sd_noise);
    YVal=[YVal;UUU];
    UUL=ones(size(UUU,1),1)*j;
    labpv=[labpv;UUL];
end% We formed a pseudo-validation set by means of colored noise injection

%A=XMOK(labSLP'==1,:);[C1, c1] = kmeans(A, r0);B=XMOK(labSLP'==2,:);[C2,c2]=kmeans(B, 3);C=XMOK(labSLP'==3,:);[C3, c3] = kmeans(C, r0);X=[c1;c2;c3];r=size(X,1);Od=ones(m1+m2,1);% We found centres for SIMILARITY FEATURES

%  X=[46   -70  -106   -86
%    112    74   -63    96
%    -47    94  -119    53
%    -58    91   -20  -114
%    108    79   -77   -69
%     88    42    99   -96
%     30    97    35    83
%    119   -96    35   -22
%    -47   -61   -69   -57
%   -124   106    60    25
%     28    48    97   111
%   -112   -79    64   103
%     83  -106    39    73
%    -75   -97    78   -76
%   -107   -83  -111    56]./100;
X=[];
for j = 1:K
    A = XMOK(labSLP'==j,:);
    r0 = 1;
    
    % modefied by linli
    
    if size(A,1) >= 2
       [C,c]=kmeans(A,2);    % how many clusters should be ??
    else
       c = A;
    end
    
    X=[X;c];
end

r=size(X,1);Od=ones(m1+m2,1);

MS=zeros(m1+m2,r); Dv=zeros(m1*Nnoise,r);
for j=1:r 
    D=[XMOK;XMOKT]-Od*X(j,:);
    MS(:,j)=sum((D.*D),2);
    d=YVal-Ov*X(j,:);
    Dv(:,j)=sum((d.*d),2);
end  % normalisation according the mean and the standard deviation

MSdat=exp(-AlFa*MS);XMOK=MSdat(1:m1,:);XMOKT=MSdat(m1+1:end,:); Yval=exp(-AlFa*Dv); % We introduced the kernel defined by its width AlFa

ko=LL*eye(r);
for j=1:K 
    ko=ko+cov(XMOK(labSLP'==j,:));
end;
[T,D,V]=svd(ko./K); % we calculated covariance matrix of the data and performed a singular value decomposition "svd"

Tt=T*sqrtm(inv(D+0.01*eye(r)));
XMOK=XMOK*Tt;XMOKT=XMOKT*Tt;XMOKT1=[XMOKT,ones(m2,1)];Yval=Yval*Tt; % we rotated and scaled the training(mok), test, and validation data sets


[WK,er,et,swtest,ET,ER,T,mse,z,y,Wmin]=perckkl(XMOK,labSLP,Yval,labpv,K,iter,step,targ,zeros(K,r+1),1,0.001); % training a set of K  SLP-perceptrons with Rummelhart cost function
%disp([ER]); figure(3);clf;plot(swtest,er,'c-','linewidth',3);% resubstitution error versus a number of batch iterations
[mx,IND1]=max(Wmin*[XMOKT,ones(m2,1)]');% for j=1:K Gj=find(IND==j);plot(XMOK(Gj,1),XMOK(Gj,2),spO(j*2+[1:2]));end  % we mark class labels of the classsified vectors

[WK,er,et,swtest,ET,ER,Wmin]=PairwiseKclassSLPs(2,XMOK,labSLP,Yval,labpv,K,Ctest,iter,step,zeros(K,r+1),1,Ctest); % training a set of K  SLP-perceptrons with our (novel-pairwise) cost function
%disp([ER]); figure(4);clf;plot(swtest,er,'c-','linewidth',3);% resubstitution error versus a number of batch iterations
[mx,IND2]=max(Wmin*[XMOKT,ones(m2,1)]');%for j=1:K Gj=find(IND==j);plot(XMOK(Gj,1),XMOK(Gj,2),spO(j*2+[1:2]));end   % mark class labels of the classsified vectors

num1 = 0;
num2 = 0;cost=0;

for i=1:m2
    if(labSLPT(i,1)==IND1(1,i))
        num1 = num1+1;
    end;
    if(labSLPT(i,1)==IND2(1,i))
        num2 = num2 +1;
    end;
    cost = cost + Ctest(labSLPT(i,1),IND2(1,i));
end

num1/m2
num2/m2
cost
    
