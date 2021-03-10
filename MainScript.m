%This is the main script
%Bora Haller; bkhaller@purdue.edu
clear
clf
clc

%ask for all initial conditions
fprintf('Please enter the following initial conditions:\n')
SStart=input('Susceptibles: ');
IStart=input('Infections: ');
RStart=input('Recovered Population: ');
spd=input('Time Steps per Day: ');
h=1/spd;
a=input('Interactions per Person per Day: ')*input('Component of Interactions That Are Sufficient to Transmit Disease: ');
b=input('The infectious period is ___ days: ');
dr=input('Death Rate: ')/b;
k=menu('Which units will you be using for your simulation time?','steps','Days');
if k==1
    nSteps=input('Simulation Steps: ');
elseif k==2
    nSteps=spd*input('Simulation Days: ');
end

%retrieve desired information
pops={'Susceptible' 'Infected' 'Recovered' 'Dead'};
m=[1];
c=0;
list=[];
while m(end)~=7 %loop to keep menu up until "finalize requests" is selected
    if c==0
        m=[];
    end
    %essentially an append command, adding each of the users selections
    %into m
    m=[m menu('Select what information you would like.','Graph of Susceptibles over time','Graph of Infections over time','Immunity Graph','Graph of Deaths over time','Threshold Pass','Peak Infections','Finalize Requests')];
    if m(end)==5 %threshold pass subroutine
        thresh=menu('Threshold Pass in which population?','Susceptible','Infected','Recovered (Immune)','Dead');
        num=input('You will be notified when the selected population reaches ');
        list=[list;thresh,num];
    end
    c=1;
end
x=0;
if numel(find(m<=4))>1 %checks if more than one graph was requested
    w=menu('Would you like your population graphs overlayed?','yes','no');
end

fprintf('\n')

%return desired information
[sHolder,iHolder,rHolder,dHolder,time]=DiseaseSimulate(SStart,IStart,RStart,h,a,b,nSteps,dr); %simulation function

if w==2 %routes for non overlayed graphs
if sum(find(m==1))>=1 %provides susceptible grph
    figure(c)
    plot(time*h,sHolder,'b-')
    xlabel('Days')
    ylabel('Susceptible Population')
    c=c+1;
end
if sum(find(m==2))>=1 %provides infected graph
    figure(c)
    plot(time*h,iHolder,'r-')
    xlabel('Days')
    ylabel('Infected Population')
    c=c+1;
end
if sum(find(m==3))>=1 %provides recovered grph
    figure(c)
    plot(time*h,rHolder,'g-')
    xlabel('Days')
    ylabel('Recovered Population')
    c=c+1;
end
if sum(find(m==4))>=1 %provides death graph
    figure(c)
    plot(time*h,dHolder,'k-')
    xlabel('Days')
    ylabel('Dead Population')
    c=c+1;
end
elseif w==1 %plots all graphs on one figure (if option is selected)
    figure(2)
    plot(time*h,sHolder,'b-')
    hold on
    plot(time*h,iHolder,'r-')
    plot(time*h,rHolder,'g-')
    plot(time*h,dHolder,'k-')
    xlabel('Days')
    ylabel('Population')
    legend('Susceptibles','Infecteds','Recovereds','Dead')
end

if sum(find(m==6))>=1 %checks if peak infections was requested
    fprintf('The peak infection count is: %.0f\n',max(iHolder))
end
if sum(find(m==5))>=1 %checks if threshold pass was requested
    vals=list(:,2); %gets all the threshhold checkpoints
    ps=list(:,1); %gets all the population types corresponding to the checkpoints
    count=0;
    for y=1:numel(ps)
        if ps(y)==1 %susceptibles pass thresholds by going below them
            instances=find(sHolder<=vals(y));
            fprintf('The Susceptible Population reaches %i on day %i after time step %i.',vals(y),floor((instances(1)-1)/spd),instances(1)-1)
        elseif ps(y)==2 && vals(y)<SStart %if its an infections threshold, the threshold could be more or less than the initial value, this is for if it is less
            instances=find(iHolder<=vals(y));
            fprintf('The Ibfected Population reaches %i on day %i after time step %i.',vals(y),floor((instances(1)-1)/spd),instances(1)-1)
        else %high infection thresholds, death thresholds, immunity thresholds
            data=[sHolder;iHolder;rHolder;dHolder];
            instances=find(data(ps(y),:)>=vals(y));
            fprintf('The %s Population reaches %i on day %i after time step %i.',string(pops(ps(y))),vals(y),floor((instances(1)-1)/spd)+1,instances(1)-1)
        end
    end
end
