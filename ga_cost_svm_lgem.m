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
            
% maxgen:最大的进化代数,默认为100,一般取值范围为[100,500]
% sizepop:种群最大数量,默认为20,一般取值范围为[20,100]
% pCrossover:交叉概率,默认为0.4,一般取值范围为[0.4,0.99]
% pMutation:变异概率,默认为0.01,一般取值范围为[0.0001,0.1]
% cbound = [cmin,cmax],参数c的变化范围,默认为[0.1,100]
% gbound = [gmin,gmax],参数g的变化范围,默认为[0.01,1000]
% v:SVM Cross Validation参数,默认为3

len_chromosome = size(train,1)-1; %feature number

% 将种群信息定义为一个结构体
individuals=struct('fitness',zeros(1,ga_option.sizepop), ...
                   'chromosome',zeros(ga_option.sizepop,len_chromosome));  
% 每一代种群的平均适应度
avgfitness_gen = zeros(1,ga_option.maxgen);         
% 每一代种群的最佳适应度
bestfitness_gen = zeros(1,ga_option.maxgen);
% 最佳适应度
bestfitness = 0;    
% 适应度最好的染色体
bestchromosome = zeros(1,len_chromosome);

%% 初始化种群
for i = 1:ga_option.sizepop
    % 编码
    individuals.chromosome(i,:) = unidrnd(2,1,len_chromosome)-1;
    % 解码
    % [c,g] = ga_decode(individuals.chromosome(i,:),ga_option.cbound,ga_option.gbound);
    % 计算初始适应度(CV准确率)
    % cmd = ['-v ',num2str(ga_option.v),' -c ',num2str( c ),' -g ',num2str( g )];
    % individuals.fitness(i) = svmtrain(train_label, train, cmd);
    individuals.fitness(i) = get_RSM(C,Q,train_label,train,individuals.chromosome(i,:));
end

% 找最佳的适应度和最好的染色体的位置
[bestfitness,bestindex]=min(individuals.fitness);
% 最好的染色体
bestchromosome = individuals.chromosome(bestindex,:);  
% 初始染色体的平均适应度
avgfitness_gen(1) = sum(individuals.fitness)/ga_option.sizepop; 

%% 迭代寻优
for i=1:ga_option.maxgen
    % Selection Operator
    individuals = Selection(individuals,ga_option);
    % Crossover Operator
    individuals = Crossover(individuals,ga_option,len_chromosome);
    % Mutation Operator
    individuals = Mutation(individuals,ga_option,len_chromosome);
    
    % 计算适应度
    for j = 1:ga_option.sizepop
        
        individuals.chromosome(j,:) = unidrnd(2,1,len_chromosome)-1;
        
        individuals.fitness(j) = get_RSM(C,Q,train_label,train,individuals.chromosome(j,:));
    end
    
    % 找最佳的适应度和最好的染色体的位置
    [new_bestfitness,bestindex]=min(individuals.fitness);
    % 最好的染色体
    new_bestchromosome = individuals.chromosome(bestindex,:);
    if new_bestfitness < bestfitness
        bestfitness = new_bestfitness;
        bestchromosome = new_bestchromosome;
    end
    
    % 这一代染色体的最佳适应度
    bestfitness_gen(i) = bestfitness;
    % 这一代染色体的平均适应度
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
    % 交叉概率决定是否进行交叉
    r = rand;
    if r > ga_option.pCrossover
        continue;
    end
    % 随机选择两个染色体进行交叉
    pick=rand(1,2);
    while prod(pick)==0
        pick=rand(1,2);
    end
    index=ceil(pick.*ga_option.sizepop);
    
    % 随机选择交叉位置
    pos_cross = unidrnd(len_chromosome-1);
    % 进行交叉
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
    % 变异概率决定是否进行交叉
    r = rand;
    if r > ga_option.pMutation
        continue;
    end
    % 随机选择一个染色体进行变异
    pick = unidrnd(ga_option.sizepop);
    % 随机选择变异位置
    pos_mutate = unidrnd(len_chromosome);
    % 进行变异
    if individuals_afterMutate.chromosome(pick,pos_mutate) == 0
       individuals_afterMutate.chromosome(pick,pos_mutate) = 1;
    else
       individuals_afterMutate.chromosome(pick,pos_mutate) = 0;
    end
end


end