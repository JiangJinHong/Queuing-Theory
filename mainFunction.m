function [meanQueue,clientTotalTime]=mainFunction(Lambda,Mu)

%生成独立泊松流
Rho=Lambda/Mu;%ρ

[s1,s2] = RandStream.create('mrg32k3a','NumStreams',2,'seed','shuffle');
r1 = "-log(rand(s1))/Lambda";
r2 = "-log(rand(s2))/Mu";

%initialization
queueLength=0;%等待队长
agentStates=0;%0无服务 1服务中
time=0.0;%当前时间
endTime=10000.0;%结束时间
disp(['仿真时间',num2str(endTime),'s']);
nextEvent=[eval(r1),endTime+1];%下一个顾客到达时间，下一个服务结束时间
nextEventKind=1;%下一个事件类型 1顾客到达 2服务结束



%-----------------------------------------------------
%用来统计的变量
clientTime=zeros(1000,3);%第一列到达时间，第二列第一次服务结束时间,第三列服务花费时间
tmpClient=1;%统计计数器
tmpServe=1;
tmpServeTime=1;
startServeTime=-1;
endServeTime=-1;
%平均等待队长
markTime1=0;
tmpTime1=1;
waitTime1=zeros(1000,2);%1值 2权

%平均队长
markTime2=0;
tmpTime2=1;
waitTime2=zeros(1000,2);

%====================================================

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
        if(queueLength>0 || agentStates==1)
           %----------------------------------
            markTime1=time-markTime1;
            markTime2=time-markTime2;
            waitTime1(tmpTime1,1)=queueLength;
            waitTime1(tmpTime1,2)=markTime1;
            tmpTime1=tmpTime1+1;
            waitTime2(tmpTime2,1)=queueLength+agentStates;
            waitTime2(tmpTime2,2)=markTime2;
            tmpTime2=tmpTime2+1;
            markTime1=time;
            markTime2=time;
            %===================================
            queueLength=queueLength+1;
        else
            %----------------------------------
            markTime2=time-markTime2;
            waitTime2(tmpTime2,1)=queueLength+agentStates;
            waitTime2(tmpTime2,2)=markTime2;
            tmpTime2=tmpTime2+1;
            markTime2=time;
            %===================================
            agentStates=1;
            %----------------------------------
            serveTime=eval(r2);
            clientTime(tmpServeTime,3)=serveTime;
            tmpServeTime=tmpServeTime+1;
            %===================================
            nextEvent(2)=time +serveTime;
        end
    case 2
        %serveClientEndEvent
        %----------------------------
        clientTime(tmpServe,2)=time;
        tmpServe=tmpServe+1;
        %============================
        if(queueLength>0)
            %----------------------------------
            markTime1=time-markTime1;
            markTime2=time-markTime2;
            waitTime1(tmpTime1,1)=queueLength;
            waitTime1(tmpTime1,2)=markTime1;
            tmpTime1=tmpTime1+1;
            waitTime2(tmpTime2,1)=queueLength+agentStates;
            waitTime2(tmpTime2,2)=markTime2;
            tmpTime2=tmpTime2+1;
            markTime1=time;
            markTime2=time;
            %===================================
            queueLength=queueLength-1;
             %----------------------------------
            serveTime=eval(r2);
            clientTime(tmpServeTime,3)=serveTime;
            tmpServeTime=tmpServeTime+1;
            %===================================
            nextEvent(2)=time + serveTime;
        else
            %----------------------------------
            markTime2=time-markTime2;
             waitTime2(tmpTime2,1)=queueLength+agentStates;
            waitTime2(tmpTime2,2)=markTime2;
            tmpTime2=tmpTime2+1;
            markTime2=time;
            %===================================
            agentStates=0;
            nextEvent(2)=endTime+1;
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
disp("完成")

%------------------------------------------------------
%平均系统时间
theoreticClientTotalTime=1/(Mu-Lambda);
clientTotalTime=clientTime(:,2)-clientTime(:,1);
tempClientTotalTime=clientTotalTime(clientTotalTime>0);%计算等待时间时还需要
clientTotalTime=mean(clientTotalTime(clientTotalTime>0));
%平均等待时间
thereticMeanWaitTime=Lambda/(Mu*(Mu-Lambda));
meanWaitTime=mean(tempClientTotalTime-clientTime(1:length(tempClientTotalTime),3));
%平均队长
theoreticMeanQueue=Rho/(1-Rho);
meanQueue=sum(waitTime2(:,1).*waitTime2(:,2))/endTime;
%平均队长方差
theoreticVarQueue=Rho/((1-Rho)^2);
varQueue=var(waitTime2(:,1),waitTime2(:,2));
%平均等待队长
theoreticMeanWaitQueue=Lambda*Lambda/(Mu*(Mu-Lambda));
meanWaitQueue=sum(waitTime1(:,1).*waitTime1(:,2))/endTime;
%===========================================================

end
