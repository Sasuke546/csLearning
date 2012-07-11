function [center_U, Mk ] = k_means_01(center_number, training_sample_DS, number_of_sampleclass)
% kmaeas聚类，center_num为中心的个数
% 功能是按照每类样本的个数比例求每类的中心，每一列为一个样本
% training_sample_DS : each colum for samples 
% training_sample_DS was read from file, for each sample the last element is
% the class type
% number_of_sampleclass: the number of class
% Modify date:2009-10-27
% return value: Mk is the number of each class's center number

k = number_of_sampleclass ;  % k denote the number of class samples
if k > center_number
        error('The number of hiddern neural number must larger than the class unmber') ;
end
[n,N] = size(training_sample_DS) ;
totalnum = N ;
if k > N     % check samples number must larger than the class number
        error('The number of samples must large than the number of class') ;
end

%%% Extract each class's training samples form DS 
Y = training_sample_DS(size(training_sample_DS,1),:) ; % the last row
X = training_sample_DS ;
tempDS = cell(1,number_of_sampleclass) ;
for i=1:k                       % class tpye : i >= 1
        tempDS{i} =  X(:,find(Y==i))  ;
        if  size(tempDS{i},2)<1 % samples number should larger than 1
                error('Each classs sample number must larger than one!') ;
        end
end

Mk = zeros(1,number_of_sampleclass) ;
for i = 1:number_of_sampleclass
    [r,c]=size(tempDS{i}) ;
    Num = (c/totalnum) * center_number;
    Mk(i) = fix( Num );
    Ms(i) = Num - Mk(i);
end
%Mk(number_of_sampleclass) = center_number - sum(Mk) ;

remaind = center_number - sum(Mk);

while (remaind >0)
        if (remaind >= number_of_sampleclass)
               % rand_vector = randperm(number_of_sampleclass);
                for xx=1:number_of_sampleclass
                        Mk(xx) = Mk(xx) + 1;    
                end
                remaind = remaind - number_of_sampleclass ;
        else
                %rand_vector = randperm(number_of_sampleclass);
                [max_v,max_i] = sort(Ms,'descend');
                for xx=1:remaind
                        Mk(max_i(xx)) = Mk(max_i(xx)) + 1;    
                end
                remaind = 0 ;
        end
end


flag = 1 ;
while flag == 1
        if min(Mk) == 0   % If the min number of Mk is zero, theft one from the largest
                index_min = find( 0 == Mk ) ;
                index_max = find( max(Mk)== Mk ) ;
                Mk(1,index_max(1,1) ) = Mk(1,index_max(1,1) ) -1 ;
                Mk(1,index_min(1,1) ) = Mk(1,index_min(1,1) ) + 1 ;
        else
                flag = 0 ;
        end
end
Mk;
center_U = [] ;
for i = 1: number_of_sampleclass
    tempDS{i}(end,:) = [] ;    
    %Mk(i)
    %tempDS{i}(:,1:Mk(i))
   % temp_Clustering = kmeans(tempDS{i}',Mk(i),'emptyaction', 'singleton'
   % ,'start' , tempDS{i}(:,1:Mk(i))' ); change by min   
   
   if(Mk(i) == 1)
            center_U =[ center_U mean(tempDS{i},2) ] ;
   else
           [IDX,C] = kmeans(tempDS{i}',Mk(i),'emptyaction', 'singleton' ,'start' , tempDS{i}(:,1:Mk(i))' );
  
   % for j=1:Mk(i)   
       % center_U = [center_U mean( tempDS{i}(:,find(temp_Clustering ==
       % j)),2)] ; changed by min       
    %end
          center_U = [center_U C'];
   end
end
