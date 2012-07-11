%  k-NN DIRECTED (COLORED) NOISE INJECTION

% Ausra Saudargiene, o  Sarunas Raudys <raudys@ktl.mii.lt> modifications
% Gaussian noise with zero mean is added to each training vector only 
% in the direction of its k nearest neighbours
% based on a paper and/or book
% Skurichina M., Raudys S., Duin R.P.W. K-nearest neighbors 
% directed noise injection in multilayer perceptron training, 
% IEEE Trans. on Neural Networks, 11:504-11, 2000.
% arba:
% Raudys S. Statistical and Neural Classifiers: 
% An integrated approach to design. Springer. London, 2001.
%

% Input:
% A - data set Na vektoriu eiluciu po p pozymiu.
% kNN - number of nearest neighbours du arba 3.
% Nnoise - number of "noise" vectors to be added to the each training vector from the
% data set A jei duomenu nedaug, galim imti Nnoise=10;
% NoiseSD - SD of noise, ususally is taken 1
% cent - scaling parameter irgi vienetas
% Output:
% NOISDATA - "noisy" data set

function NOISDATA=ColorGAUSnoise(A,kNN,Nnoise,NoiseSD);

[Na,p]=size(A);AT=A';%  is noise standard deviation

% modefied by linli
if Na == 2
    l = 1; r = 2;
else
    if Na == 1
        l = 1; r = 1; kNN = 1;
    else
        l = 2; r = kNN+1;
    end
end

NOISDATA=[];ONESV=ones(kNN,1);ONESH=ones(1,p);ONESDATA=ones(1,Na);

for i=1:Na 
    dd=A(i,:)'*ONESDATA-AT;d=sum(dd.*dd);%finding distances to all data vectors
    [ds,ind]=sort(d);% sort distances

%closests_kNN=A([ind(2:kNN+1)],:); %INDICES(i,1:KN)=ind(2:KN+1);%selecting KN earest neighbours 
closests_kNN=A([ind(l:r)],:); %INDICES(i,1:KN)=ind(2:KN+1);%selecting KN earest neighbours 

DISTANCES=NoiseSD*(closests_kNN-ONESV*A(i,:));% scaled by noise standard deviation distances to K nearest neighbours
  %adding a noise Marina
  for nv=1:Nnoise    %number of noise vectors around one sample
     deltam=(randn(kNN,1)*ONESH).*DISTANCES;% RANDOM*(distances to KN nearest neighbours)
     noism(nv,:)=A(i,:)+(sum(deltam));%noism(nv,:)=A(i,:)+(cent*mean(deltam));% we add a mean of KN random  distances to NN vectors
  end
  NOISDATA=[NOISDATA;noism];
end   
return
%for testing and understanding
%a=randn(20,2);A=[a(:,1),0.1*a(:,2)+a(:,1).^2];BN=coloredGnoise(A,2,3,1,0.6);figure(1);plot(A(:,1),A(:,2),'ro',BN(:,1),BN(:,2),'g.');