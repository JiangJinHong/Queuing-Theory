function [meanQueue,clientTotalTime]=mainFunction(Lambda,Mu)

%���ɶ���������
Rho=Lambda/Mu;%��

[s1,s2] = RandStream.create('mrg32k3a','NumStreams',2,'seed','shuffle');
r1 = "-log(rand(s1))/Lambda";
r2 = "-log(rand(s2))/Mu";

%initialization
queueLength=0;%�ȴ��ӳ�
agentStates=0;%0�޷��� 1������
time=0.0;%��ǰʱ��
endTime=10000.0;%����ʱ��
disp(['����ʱ��',num2str(endTime),'s']);
nextEvent=[eval(r1),endTime+1];%��һ���˿͵���ʱ�䣬��һ���������ʱ��
nextEventKind=1;%��һ���¼����� 1�˿͵��� 2�������



%-----------------------------------------------------
%����ͳ�Ƶı���
clientTime=zeros(1000,3);%��һ�е���ʱ�䣬�ڶ��е�һ�η������ʱ��,�����з��񻨷�ʱ��
tmpClient=1;%ͳ�Ƽ�����
tmpServe=1;
tmpServeTime=1;
startServeTime=-1;
endServeTime=-1;
%ƽ���ȴ��ӳ�
markTime1=0;
tmpTime1=1;
waitTime1=zeros(1000,2);%1ֵ 2Ȩ

%ƽ���ӳ�
markTime2=0;
tmpTime2=1;
waitTime2=zeros(1000,2);

%====================================================

%������
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
disp("���")

%------------------------------------------------------
%ƽ��ϵͳʱ��
theoreticClientTotalTime=1/(Mu-Lambda);
clientTotalTime=clientTime(:,2)-clientTime(:,1);
tempClientTotalTime=clientTotalTime(clientTotalTime>0);%����ȴ�ʱ��ʱ����Ҫ
clientTotalTime=mean(clientTotalTime(clientTotalTime>0));
%ƽ���ȴ�ʱ��
thereticMeanWaitTime=Lambda/(Mu*(Mu-Lambda));
meanWaitTime=mean(tempClientTotalTime-clientTime(1:length(tempClientTotalTime),3));
%ƽ���ӳ�
theoreticMeanQueue=Rho/(1-Rho);
meanQueue=sum(waitTime2(:,1).*waitTime2(:,2))/endTime;
%ƽ���ӳ�����
theoreticVarQueue=Rho/((1-Rho)^2);
varQueue=var(waitTime2(:,1),waitTime2(:,2));
%ƽ���ȴ��ӳ�
theoreticMeanWaitQueue=Lambda*Lambda/(Mu*(Mu-Lambda));
meanWaitQueue=sum(waitTime1(:,1).*waitTime1(:,2))/endTime;
%===========================================================

end
