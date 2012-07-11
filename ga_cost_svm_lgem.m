% svm feature selection with L-GEM

% reference gaSVMcgForClass
% by faruto
% Email:farutoliyang@gmail.com
% 2009.10.07

% modefied by Lin Li 2011-9-25

% parameter
% train,train_label -> original dataset in UCI


function [ bestchromosome ] = ga_cost_svm_lgem(C,Q, train_label,train )

ti = cputime;
    ga_option = struct('maxgen',100,'sizepop',20,'pCrossover',0.4,'pMutation',0.01, ...
                'cbound',[0.1,100],'gbound',[0.01,1000],'v',3);
            
% maxgen:���Ľ�������,Ĭ��Ϊ100,һ��ȡֵ��ΧΪ[100,500]
% sizepop:��Ⱥ�������,Ĭ��Ϊ20,һ��ȡֵ��ΧΪ[20,100]
% pCrossover:�������,Ĭ��Ϊ0.4,һ��ȡֵ��ΧΪ[0.4,0.99]
% pMutation:�������,Ĭ��Ϊ0.01,һ��ȡֵ��ΧΪ[0.0001,0.1]
% cbound = [cmin,cmax],����c�ı仯��Χ,Ĭ��Ϊ[0.1,100]
% gbound = [gmin,gmax],����g�ı仯��Χ,Ĭ��Ϊ[0.01,1000]
% v:SVM Cross Validation����,Ĭ��Ϊ3

len_chromosome = size(train,1)-1; %feature number

% ����Ⱥ��Ϣ����Ϊһ���ṹ��
individuals=struct('fitness',zeros(1,ga_option.sizepop), ...
                   'chromosome',zeros(ga_option.sizepop,len_chromosome));  
% ÿһ����Ⱥ��ƽ����Ӧ��
avgfitness_gen = zeros(1,ga_option.maxgen);         
% ÿһ����Ⱥ�������Ӧ��
bestfitness_gen = zeros(1,ga_option.maxgen);
% �����Ӧ��
bestfitness = 0;    
% ��Ӧ����õ�Ⱦɫ��
bestchromosome = zeros(1,len_chromosome);

%% ��ʼ����Ⱥ
for i = 1:ga_option.sizepop
    % ����
    individuals.chromosome(i,:) = unidrnd(2,1,len_chromosome)-1;
    % ����
    % [c,g] = ga_decode(individuals.chromosome(i,:),ga_option.cbound,ga_option.gbound);
    % �����ʼ��Ӧ��(CV׼ȷ��)
    % cmd = ['-v ',num2str(ga_option.v),' -c ',num2str( c ),' -g ',num2str( g )];
    % individuals.fitness(i) = svmtrain(train_label, train, cmd);
    individuals.fitness(i) = get_RSM(C,Q,train_label,train,individuals.chromosome(i,:));
end

% ����ѵ���Ӧ�Ⱥ���õ�Ⱦɫ���λ��
[bestfitness,bestindex]=min(individuals.fitness);
% ��õ�Ⱦɫ��
bestchromosome = individuals.chromosome(bestindex,:);  
% ��ʼȾɫ���ƽ����Ӧ��
avgfitness_gen(1) = sum(individuals.fitness)/ga_option.sizepop; 

%% ����Ѱ��
for i=1:ga_option.maxgen
    % Selection Operator
    individuals = Selection(individuals,ga_option);
    % Crossover Operator
    individuals = Crossover(individuals,ga_option,len_chromosome);
    % Mutation Operator
    individuals = Mutation(individuals,ga_option,len_chromosome);
    
    % ������Ӧ��
    for j = 1:ga_option.sizepop
        
        individuals.chromosome(j,:) = unidrnd(2,1,len_chromosome)-1;
        
        individuals.fitness(j) = get_RSM(C,Q,train_label,train,individuals.chromosome(j,:));
    end
    
    % ����ѵ���Ӧ�Ⱥ���õ�Ⱦɫ���λ��
    [new_bestfitness,bestindex]=min(individuals.fitness);
    % ��õ�Ⱦɫ��
    new_bestchromosome = individuals.chromosome(bestindex,:);
    if new_bestfitness < bestfitness
        bestfitness = new_bestfitness;
        bestchromosome = new_bestchromosome;
    end
    
    % ��һ��Ⱦɫ��������Ӧ��
    bestfitness_gen(i) = bestfitness;
    % ��һ��Ⱦɫ���ƽ����Ӧ��
    avgfitness_gen(i) = sum(individuals.fitness)/ga_option.sizepop;
    
end

cputime - ti

end

%% sub function get_RSM
function rsm = get_RSM(C,Q,t_l,t,chr)

n = 1;

numFea = size(find(chr==1),2);

DS_train = zeros(numFea,size(t,2));

for i = 1:size(chr,2)
    if chr(1,i) == 1
        DS_train(n,:) = t(i,:);
        n = n + 1;
    end
end

if n == 1
    rsm = 999999999;
else
    model =  svmtrain(t_l', DS_train');
    [ans_label, acc, dicision_value ] = svmpredict(t_l',DS_train', model);
    rsm = get_Rsm_cost_svm(C,Q,DS_train',t_l',ans_label,model,dicision_value);
end

end


% %% sub function ga_decode
% function [c,g] = ga_decode(chromosome,cbound,gbound)
% % ga_decode by faruto 
% % Email:farutoliyang@gmail.com
% % 2009.10.08
% 
% % modfied by Lin Li 2011-9-25
% 
% c_len_chromosome = ceil(log2((cbound(2)-cbound(1))*100));
% g_len_chromosome = ceil(log2((gbound(2)-gbound(1))*100));
% len_chromosome = c_len_chromosome+g_len_chromosome;
% 
% cdec = bin2dec( num2str(chromosome(1:c_len_chromosome)) );
% gdec = bin2dec( num2str(chromosome(c_len_chromosome+1:len_chromosome)) );
% 
% c = cbound(1) + cdec*(cbound(2)-cbound(1))/(2^(c_len_chromosome)-1);
% g = gbound(1) + gdec*(gbound(2)-gbound(1))/(2^(g_len_chromosome)-1);

%% sub function Selection
function individuals_afterSelect = Selection(individuals,ga_option)
% Selection by faruto 
% Email:farutoliyang@gmail.com
% 2009.10.08
individuals_afterSelect = individuals;
sum_fitness = sum(individuals.fitness);
P = individuals.fitness / sum_fitness;
Q = zeros(1,ga_option.sizepop);
for k = 1:ga_option.sizepop
    Q(k) = sum(P(1:k));
end

for i = 1:ga_option.sizepop
    r = rand;
    while r == 0
        r = rand;
    end
    k = 1;
    while k <= ga_option.sizepop-1 && r > Q(k) 
        k = k+1; 
    end
%     individuals_afterSelect.fitness(i) = individuals.fitness(k);
    individuals_afterSelect.chromosome(i,:) = individuals.chromosome(k,:);
end

end

%% sub function Crossover
function individuals_afterCross = Crossover(individuals,ga_option,len_chromosome)
% Crossover by faruto 
% Email:farutoliyang@gmail.com
% 2009.10.08
individuals_afterCross = individuals;
% c_len_chromosome = ceil(log2((ga_option.cbound(2)-ga_option.cbound(1))*100));
% g_len_chromosome = ceil(log2((ga_option.gbound(2)-ga_option.gbound(1))*100));
% len_chromosome = c_len_chromosome+g_len_chromosome;

for i = 1:ga_option.sizepop
    % ������ʾ����Ƿ���н���
    r = rand;
    if r > ga_option.pCrossover
        continue;
    end
    % ���ѡ������Ⱦɫ����н���
    pick=rand(1,2);
    while prod(pick)==0
        pick=rand(1,2);
    end
    index=ceil(pick.*ga_option.sizepop);
    
    % ���ѡ�񽻲�λ��
    pos_cross = unidrnd(len_chromosome-1);
    % ���н���
    individuals_afterCross.chromosome(index(1),pos_cross+1:len_chromosome) ...
        = individuals.chromosome(index(2),pos_cross+1:len_chromosome);
    individuals_afterCross.chromosome(index(2),pos_cross+1:len_chromosome) ...
        = individuals.chromosome(index(1),pos_cross+1:len_chromosome);
end

end

%% sub function Mutation
function individuals_afterMutate = Mutation(individuals,ga_option,len_chromosome)
% Mutation by faruto 
% Email:farutoliyang@gmail.com
% 2009.10.08
individuals_afterMutate = individuals;
% c_len_chromosome = ceil(log2((ga_option.cbound(2)-ga_option.cbound(1))*100));
% g_len_chromosome = ceil(log2((ga_option.gbound(2)-ga_option.gbound(1))*100));
% len_chromosome = c_len_chromosome+g_len_chromosome;

for i = 1:ga_option.sizepop
    % ������ʾ����Ƿ���н���
    r = rand;
    if r > ga_option.pMutation
        continue;
    end
    % ���ѡ��һ��Ⱦɫ����б���
    pick = unidrnd(ga_option.sizepop);
    % ���ѡ�����λ��
    pos_mutate = unidrnd(len_chromosome);
    % ���б���
    if individuals_afterMutate.chromosome(pick,pos_mutate) == 0
       individuals_afterMutate.chromosome(pick,pos_mutate) = 1;
    else
       individuals_afterMutate.chromosome(pick,pos_mutate) = 0;
    end
end


end