clear;
clc;
%生成独立泊松流
Lambda=input("请输入到达泊松流参数λ=");%λ
Mu1=input("请输入第一级服务事件负指数分布参数μ1=");%μ
Mu2=input("请输入第二级服务事件负指数分布参数μ2=");%μ
[s1,s2,s3] = RandStream.create('mrg32k3a','NumStreams',3,'seed','shuffle');
r1 = "-log(rand(s1))/Lambda";
r2 = "-log(rand(s2))/Mu1";
r3 = "-log(rand(s2))/Mu2";

%initialization
queueLength1=0;%第一级等待队长
queueLength2=0;%第二级等待队长

agentStates1=0;%第一级0无服务1服务中
agentStates2=0;%第二级0无服务1服务中





time=0.0;%当前时间
endTime=10000.0;%结束时间
disp(['仿真时间',num2str(endTime),'s']);
nextEvent=[eval(r1),endTime+1,endTime+1];%{下一个顾客到达时间，第一级下一个服务结束时间,第二级下一个服务结束时间}
nextEventKind=1;%下一个事件类型1顾客到达，2第一级服务结束,3第二级服务结束

%-----------------------------------------------------
%用来统计的变量
clientTime=zeros(10000,3);%第一列到达时间，第二列第一次服务结束时间，第三列第二次服务结束时间
tmpClient=1;%统计计数器
tmpServe1=1;
tmpServe2=1;
%平均等待队长
markTime1=0;
tmpTime1=1;
waitTime1=zeros(1000,2);%第一级队列 1值 2权
markTime2=0;
tmpTime2=1;
waitTime2=zeros(1000,2);%第二级队列 1值 2权

markTime3=0;
tmpTime3=1;
waitTime3=zeros(1000,2);%总队列 1值 2权

%============================================--

%主程序
while(time<endTime)
    switch nextEventKind
    case 1
        
        %clientComingEvent
        %----------------------------
        clientTime(tmpClient,1)=time;
        tmpClient=tmpClient+1;
        %============================
        nextEvent(1)=time + eval(r1);
        if(queueLength1>0 || agentStates1==1)
            %----------------------------------
            markTime1=time-markTime1;
            markTime3=time-markTime3;
            waitTime1(tmpTime1,1)=queueLength1;
            waitTime1(tmpTime1,2)=markTime1;
            waitTime3(tmpTime3,1)=queueLength1+queueLength2;
            waitTime3(tmpTime3,2)=markTime3;
            tmpTime1=tmpTime1+1;
            tmpTime3=tmpTime3+1;
            markTime1=time;
            markTime3=time;
            %===================================
            queueLength1=queueLength1+1;
        else
            agentStates1=1;
            nextEvent(2)=time +eval(r2);
        end
    case 2
        
        %serve1ClientEndEvent
        %----------------------------
        clientTime(tmpServe1,2)=time;
        tmpServe1=tmpServe1+1;
        %============================
        if(queueLength1>0)
            %----------------------------------
            markTime1=time-markTime1;
            markTime3=time-markTime3;
            waitTime1(tmpTime1,1)=queueLength1;
            waitTime1(tmpTime1,2)=markTime1;
            waitTime3(tmpTime3,1)=queueLength1+queueLength2;
            waitTime3(tmpTime3,2)=markTime3;
            tmpTime1=tmpTime1+1;
            tmpTime3=tmpTime3+1;
            markTime1=time;
            markTime3=time;
            %===================================
            queueLength1=queueLength1-1;
            nextEvent(2)=time + eval(r2);
        else
            agentStates1=0;
            nextEvent(2)=endTime+1;
        end
        
        if(queueLength2>0 || agentStates2==1)
            %----------------------------------
            markTime2=time-markTime2;
            markTime3=time-markTime3;
            waitTime2(tmpTime2,1)=queueLength2;
            waitTime2(tmpTime2,2)=markTime2;
            waitTime3(tmpTime3,1)=queueLength2+queueLength1;
            waitTime3(tmpTime3,2)=markTime3;
            tmpTime2=tmpTime2+1;
            tmpTime3=tmpTime3+1;
            markTime2=time;
            markTime3=time;
            %===================================
            queueLength2=queueLength2+1;
        else
            agentStates2=1;
            nextEvent(3)=time +eval(r3);
        end
    case 3
        
         %serve2ClientEndEvent
         %----------------------------
         clientTime(tmpServe2,3)=time;
         tmpServe2=tmpServe2+1;
         %============================
         if(queueLength2>0)
             %----------------------------------
            markTime2=time-markTime2;
            markTime3=time-markTime3;
            waitTime2(tmpTime2,1)=queueLength2;
            waitTime2(tmpTime2,2)=markTime2;
            waitTime3(tmpTime3,1)=queueLength2+queueLength1;
            waitTime3(tmpTime3,2)=markTime3;
            tmpTime2=tmpTime2+1;
            tmpTime3=tmpTime3+1;
            markTime2=time;
            markTime3=time;
            %===================================
            queueLength2=queueLength2-1;
            nextEvent(3)=time + eval(r3);
        else
            agentStates2=0;
            nextEvent(3)=endTime+1;
         end
    otherwise
        disp(['error happen at ',time]);
        time=endTime+1;   
    end
    %NextEventTime
    [newTime,newEventKind]=min(nextEvent);
    time=newTime;
    nextEventKind=newEventKind;
    
end
disp("完成仿真")

%------------------------------------------------------
%平均系统时间
theoreticClientTotalTime=1/(Mu1-Lambda)+1/(Mu2-Lambda);
disp(['平均系统时间理论值=',num2str(theoreticClientTotalTime)]);
clientTotalTime=clientTime(:,3)-clientTime(:,1);
tempClientTotalTime=clientTotalTime(clientTotalTime>0);
clientTotalTime=mean(tempClientTotalTime);
%hist(tempClientTotalTime,1000);
disp(['平均系统时间仿真值=',num2str(clientTotalTime)])
%平均队长
%第一级
meanWaitQueue1=sum(waitTime1(:,1).*waitTime1(:,2))/endTime;
disp(['第一级平均等待队长仿真值=',num2str(meanWaitQueue1)]);
tongji1=zeros(max(waitTime1(:,1))+1,1);
for i=0:max(waitTime1(:,1))
    for j=1:length(waitTime1(:,1))
        if (waitTime1(j,1))==i
        tongji1(i+1)=tongji1(i+1)+waitTime1(j,2);
        end 
    end
end
figure(1)
set(figure(1),'name',['仿真时间',num2str(endTime),'s,λ=',num2str(Lambda)],'Numbertitle','off');
subplot(1,3,1); 
bar(0:length(tongji1)-1,tongji1);
title(['第一级等待队长分布','参数μ1=',num2str(Mu1)]);
xlabel('队长'); ylabel('总时长');
%第二级
meanWaitQueue2=sum(waitTime2(:,1).*waitTime2(:,2))/endTime;
tongji2=zeros(max(waitTime2(:,1))+1,1);
for i=0:max(waitTime2(:,1))
    for j=1:length(waitTime2(:,1))
        if (waitTime2(j,1))==i
        tongji2(i+1)=tongji2(i+1)+waitTime2(j,2);
        end 
    end
end
subplot(1,3,2);
bar(0:length(tongji2)-1,tongji2);
title(['第二级等待队长分布','参数μ2=',num2str(Mu2)]);
xlabel('队长'); ylabel('总时长');
disp(['第二级平均等待队长仿真值=',num2str(meanWaitQueue2)]);
%总队长
meanWaitQueue3=sum(waitTime3(:,1).*waitTime3(:,2))/endTime;
disp(['总平均等待队长仿真值=',num2str(meanWaitQueue3)]);
tongji3=zeros(max(waitTime3(:,1))+1,1);
for i=0:max(waitTime3(:,1))
    for j=1:length(waitTime3(:,1))
        if (waitTime3(j,1))==i
        tongji3(i+1)=tongji3(i+1)+waitTime3(j,2);
        end 
    end
end
subplot(1,3,3); 
bar(0:length(tongji3)-1,tongji3);
title('总等待队长分布');
xlabel('队长'); ylabel('总时长');
%======================================================
