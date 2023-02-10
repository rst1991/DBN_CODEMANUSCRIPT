function [rmse,denoisedI] = fitnessfunctionTest(In,Out,Pop)


num = 1000;
nodes = [32 16 8 4];

IN = rand(num,32);
OUT = rand(num,4);
In= In;
Out=Out;
dnn = randDBN( nodes );
%dnn = randDBN( nodes, 'BBPDBN' ); % ICPR 2014
%dnn = randDBN( nodes, 'GBDBN' );
nrbm = numel(dnn.rbm);

opts.MaxIter = 20;
opts.BatchSize = num/4;
opts.Verbose = true;
opts.StepRatio = Pop(1);
opts.DropOutRate = Pop(2);
opts.Object = 'CrossEntropy';

dnn = pretrainDBN(dnn, IN, opts);
dnn= SetLinearMapping(dnn, IN, OUT);

opts.Layer = 0;
dnn = trainDBN(dnn, IN, OUT, opts);
[rmse,AveErrNum,denoisedI]  = CalcRmseTest(dnn, IN, OUT,In);