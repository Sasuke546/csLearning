% PairwiseKclassSLPs Linear discriminants by K pairwise non-linear SLPs 
% it is trained by SR@AR SUGGESTED NOVEL COST FUNCTION, see IEEET PAMI, 2010 N7.
% Author Sarunas Raudys, sarunas.raudys@mif.vu.lt
% a - training data, lab - labels - class numbers (1, 2, ... ) of each  single  training vector
% at AND labt - the same, tor test (validation set)
% if we have classification errors is gama=1.000; if classification error is zero it is worth using  gama=1.0001 or gamma=1.01;
% to save computer time in array  "wtest" we place numbers of batch iterations  when we calculated classification errors 
% er - training history
% et - test (validation) history used to determine an optimal number of batch iterations
% ET   -    K x K table of allocation error (in test-validation), K is a number of classes
% ER   -    yje same, only for training (resubstitution) errors.
% W - K x (p+1) dimensional array of K   p+1 dimensional weight vectors (w1, w2, ... , wp, w0. 
% Wmin = "best" weight vectors, where we have had minimum mumber of test/validation error
% Ctrain - K x K dimensional matrix of cost used in training phase. 
% We assume, that, in principle, Ctest and Ctrain can be different matrices
% Ctest - K x K dimensional matrix of cost used in test/validation phase
% etR   classification error matrix multiplied by K xK dimensional cost (for test) matrix
% swtest - current number of iterations when we estimate the test-set error "etest"
function [W,er,et,swtest,ET,ER,Wmin,etR]=PairwiseKclassSLPs(alfa,a,nlab,at,nlabt,K,Ctrain,iter,step,Wstart,gama,Ctest)
swtest=[[1:min(iter,10)],[12:2:min(iter,30)],[35:5:min(iter,100)],[110:10:min(iter,300)],[320:20:min(iter,500)],[550:50:min(iter,1000000)]];

SWIP=1;[n,p]=size(a);a=[a,ones(n,1)];EE=1-eye(K);
[nt,pt]=size(at);at=[at,ones(nt,1)];minerror=nt;alfa1=alfa-1;
	      W=Wstart;stepz=2*step/n;
          
for i=1:iter jh=(i/iter)^2; Ctrainn=Ctrain;
    for ki=1:K aki=a(find(nlab== ki),:);
        for kj=1:K 
                if ki~=kj 
                     d=aki*(W(ki,:)-W(kj,:))';outp=1./(1+exp(-d));
                        % to speed up calculations, one needs to change an order of calculations of scalar products, aki*(W(ki,:),
                        % and instead of calculation of the exponent "exp", use a lookup table
                     if alfa==1 Z=Ctrainn(ki,kj).*((outp).*(outp-outp.*outp))'*aki;else Z=Ctrainn(ki,kj).*(((outp).^alfa1).*(outp-outp.*outp))'*aki;end
                     W(ki,:)= W(ki,:)+stepz*Z;W(kj,:)= W(kj,:)-stepz*Z;
                end
        end;
    end    
	if i==1 
        Wmin=W;
    end;
    if i==swtest(SWIP) 
        [mx,IND]=max(W*a');er(SWIP)=sum(abs(sign(-nlab'+IND))); 
        [mx,IND]=max(W*at');et(SWIP)=sum(abs(sign(-nlabt'+IND)));
%         num = 0;
%         for i = 1:n
%             if(nlabt(i,1)==IND(1,i))
%                 num = num+1;
%             end
%         end
%         num/n
        Et=zeros(K,K);
        for i1=1:nt 
            Et(nlabt(i1),IND(i1))=Et(nlabt(i1),IND(i1))+1; 
        end;
        etR(SWIP)=sum(sum(Ctest.*Et));
        if et(SWIP) < minerror 
            minerror = et(SWIP);
            Wmin=W;
        end; 
        SWIP=SWIP+1;
    end
   	stepz=stepz*gama;	
end;   

ET=zeros(K,K);ER=ET;
for i1=1:nt 
    ET(nlabt(i1),IND(i1))=ET(nlabt(i1),IND(i1))+1; 
end; % fills up array ET  

[mx,IND]=max(W*a'); 

for i1=1:n 
    ER(nlab(i1),IND(i1))=ER(nlab(i1),IND(i1))+1; 
end; % suraso ER  

swtest=swtest(1:SWIP-1);et=et./nt;er=er./n;etR=etR./nt;

return







