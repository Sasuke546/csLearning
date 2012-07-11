
Train_name = 'UCID_proposed9_294_MB1_05\\UCID_proposed9_294_MB1_05_tr';

Test_name = 'UCID_proposed9_294_MB1_05\\UCID_proposed9_294_MB1_05_te';

load gen_DS.mat;

fre = fopen('UCID_proposed9_294_MB1_05.txt','w+');

for i = 1:10
    
    trainname = strcat(Train_name,num2char(i),'.txt');
    Train = load(trainname);
    Train_label = Train(:,end);
    Train = Train(:,1:end-1);

    
    testname = strcat(Test_name,num2char(i),'.txt');
    Test = load(testname);
    Test_label = Test(:,end);
    Test = Test(:,1:end-1);
    
    CM = zeros(2,2);  % nothing
    
    [acc,x] = ga_cost_svm_lgem_matlab_ckt(CM,0.001,Train_label',Train',Test_label',Test',gen_DS);
    
    fprintf(fre,'%f\n',acc);
    fprintf(fre,'%d ',x);
    fprintf(fre,'\n');
    
end

fclose(fre);