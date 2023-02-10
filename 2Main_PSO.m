clc;
clear all;
close all;
addpath('DNN')

[filename, pathname] = uigetfile('./ImageDataset/*.*');

answer = inputdlg('Enter the noise level(15%,25%,50%) : ','Noise Level');

if strcmp(answer,'15') || strcmp(answer,'15%')
    noise = 15;
    sigma1 = (noise/255)^2;
elseif strcmp(answer,'25') || strcmp(answer,'25%')
    noise = 25;
    sigma1 = (noise/255)^2;
elseif strcmp(answer,'50') || strcmp(answer,'50%')
    noise = 50;
    sigma1 =(noise/255)^2;
else
    noise = 15;
    sigma1 = (noise/255)^2;
end


I = imread([pathname filename]);
I = imresize(I,[256 256]);

if size(I,3) > 1
    I = rgb2gray(I);
else
    I = I;
end

noisyI = imnoise(I,'gaussian',0,sigma1);

figure
imshowpair(I,noisyI,'montage');
title('Original Image (left) and Noisy Image (right)')

Pop = rand(5,2);

SearchAgents_no = 5;
Max_iter = 1;
lb = 0;
ub = 1;
dim  = 2;

% initialize position vector and score for the leader
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems


%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);

Convergence_curve=zeros(1,Max_iter);



t=0;% Loop counter

% Main loop
while t<Max_iter
    
    %% Calculate fitness Function
    
    for i=1:size(Positions,1)
        
        % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        % Calculate objective function for each search agent
        fitness(i)=fitnessfunction(noisyI,I,Positions(i,:));
        
        % Update the leader
        if fitness(i)<Leader_score % Change this to > for maximization problem
            Leader_score=fitness(i); % Update alpha
            Leader_pos=Positions(i,:);
        end
        
    end
    [mindata,idx] =sort(fitness);
    fmin = min(fitness);
    Lbest = Positions(idx(end),:);
    c1 = 0.2;
    c2 = 0.2;
    Vel = zeros(size(Positions));
    w=1;
    for i=1:size(Positions,1)
        for j = 1:size(Positions,2)
            Vel(i,j) = (w*Vel(i,j))+(rand * c1 *(Positions(i,j) - Lbest(1,j)))+(rand*c2*(Positions(i,j) - Leader_pos(1,j)));
            newpos(i,j) = abs(Vel(i,j)+ Positions(i,j));
            if (newpos(i,j) > 1) || (newpos(i,j) < 1e-3)
                newpos(i,j) = rand;
            end
            
            
            
        end
    end
    Positions = newpos;
    t=t+1;
    Convergence_curve(t)=Leader_score;
    [t Leader_score]
end


