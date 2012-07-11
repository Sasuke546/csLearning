% Standandard K class net of K SLPs Linear discriminants aimed to discriminate K pattern classes
% it is trained by Rummelhart sum of squares cost function
% author Sarunas Raudys, sarunas.raudys@mif.vu.lt
% a training data, lab - labels - class numbers (1, 2, ... ) of each  single  training vector
% at ir labt - the same, tor test (validation set)
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
% swtest - current number of iterations when we estimate the test-set error
% "etest"

function [W,er,et,swtest,ET,ER,T,mse,z,y,Wmin]=perckkl(a,nlab,at,nlabt,k,iter,step,target,Wstart,gama,Gg)
swtest=[[1:min(iter,10)],[12:2:min(iter,30)],[35:5:min(iter,100)],[110:10:min(iter,300)],[320:20:min(iter,500)],[550:50:min(iter,1000000)]];
% swtest - current number of iterations when we estimate the test-set error "etest"
SWIP=1;[n,p]=size(a);a=[a,ones(n,1)];
[nt,pt]=size(at);at=[at,ones(nt,1)];minerror=nt;
	T = eye(k)*target; 
	T(find(T==0)) = (1-target)*ones(sum(sum(T==0)),1); 
	T = reshape(T,k,k);
      T = T(nlab,:); % surandu targetus kiekvienai klasei
      W=Wstart;stepz=2*step/n;
ER=[];for j=1:1000 c=Gg*j;ER(j)=sum(sum((T-1./(1+exp(-c*a*W'))).^2));end;[z,y]=min(ER);W=y*Gg*Wstart; % cia cikle randu geriausia daugiklio "y*Gg" reiksme is kurio padauginus pradini svoriu vektoriu "Wstart" gaunamas maziausias "sokas" per pirma mokymo iteracija.
% Jei tas koeficientas butu per didelis ar per mazas, tai  pirma isteracija "iskraipytu" gera inicializavima, ir gero Wstart nebutu jokios naudos.
for i=1:iter d=a*W'; f=1./(1+exp(-d));Z=((T-f).*(f-f.*f))'*a;
	W  = W+stepz*Z;if i==1 Wmin=W;end;if i==swtest(SWIP) 
[mx,IND]=max(W*a');er(SWIP)=sum(abs(sign(-nlab'+IND))); mse(SWIP)=sum(sum((T-f).^2));
[mx,IND]=max(W*at');et(SWIP)=sum(abs(sign(-nlabt'+IND)));
if et(SWIP) < minerror minerror = et(SWIP);Wmin=W;end; SWIP=SWIP+1;end
   	stepz=stepz*gama;	end;   ET=zeros(k,k);ER=ET;
for i1=1:nt ET(nlabt(i1),IND(i1))=ET(nlabt(i1),IND(i1))+1; end; % suraso ET  
[mx,IND]=max(W*a'); for i1=1:n ER(nlab(i1),IND(i1))=ER(nlab(i1),IND(i1))+1; end; % suraso ER  
swtest=swtest(1:SWIP-1);et=et./nt;er=er./n;mse=mse/n/k;
return







