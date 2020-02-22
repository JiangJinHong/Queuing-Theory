clear;
clc;
%���ɶ���������
Lambda=input("�����뵽�ﲴ����������=");%��
Mu1=input("�������һ�������¼���ָ���ֲ�������1=");%��
Mu2=input("������ڶ��������¼���ָ���ֲ�������2=");%��
[s1,s2,s3] = RandStream.create('mrg32k3a','NumStreams',3,'seed','shuffle');
r1 = "-log(rand(s1))/Lambda";
r2 = "-log(rand(s2))/Mu1";
r3 = "-log(rand(s2))/Mu2";

%initialization
queueLength1=0;%��һ���ȴ��ӳ�
queueLength2=0;%�ڶ����ȴ��ӳ�

agentStates1=0;%��һ��0�޷���1������
agentStates2=0;%�ڶ���0�޷���1������





time=0.0;%��ǰʱ��
endTime=10000.0;%����ʱ��
disp(['����ʱ��',num2str(endTime),'s']);
nextEvent=[eval(r1),endTime+1,endTime+1];%{��һ���˿͵���ʱ�䣬��һ����һ���������ʱ��,�ڶ�����һ���������ʱ��}
nextEventKind=1;%��һ���¼�����1�˿͵��2��һ���������,3�ڶ����������

%-----------------------------------------------------
%����ͳ�Ƶı���
clientTime=zeros(10000,3);%��һ�е���ʱ�䣬�ڶ��е�һ�η������ʱ�䣬�����еڶ��η������ʱ��
tmpClient=1;%ͳ�Ƽ�����
tmpServe1=1;
tmpServe2=1;
%ƽ���ȴ��ӳ�
markTime1=0;
tmpTime1=1;
waitTime1=zeros(1000,2);%��һ������ 1ֵ 2Ȩ
markTime2=0;
tmpTime2=1;
waitTime2=zeros(1000,2);%�ڶ������� 1ֵ 2Ȩ

markTime3=0;
tmpTime3=1;
waitTime3=zeros(1000,2);%�ܶ��� 1ֵ 2Ȩ

%============================================--

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
disp("��ɷ���")

%------------------------------------------------------
%ƽ��ϵͳʱ��
theoreticClientTotalTime=1/(Mu1-Lambda)+1/(Mu2-Lambda);
disp(['ƽ��ϵͳʱ������ֵ=',num2str(theoreticClientTotalTime)]);
clientTotalTime=clientTime(:,3)-clientTime(:,1);
tempClientTotalTime=clientTotalTime(clientTotalTime>0);
clientTotalTime=mean(tempClientTotalTime);
%hist(tempClientTotalTime,1000);
disp(['ƽ��ϵͳʱ�����ֵ=',num2str(clientTotalTime)])
%ƽ���ӳ�
%��һ��
meanWaitQueue1=sum(waitTime1(:,1).*waitTime1(:,2))/endTime;
disp(['��һ��ƽ���ȴ��ӳ�����ֵ=',num2str(meanWaitQueue1)]);
tongji1=zeros(max(waitTime1(:,1))+1,1);
for i=0:max(waitTime1(:,1))
    for j=1:length(waitTime1(:,1))
        if (waitTime1(j,1))==i
        tongji1(i+1)=tongji1(i+1)+waitTime1(j,2);
        end 
    end
end
figure(1)
set(figure(1),'name',['����ʱ��',num2str(endTime),'s,��=',num2str(Lambda)],'Numbertitle','off');
subplot(1,3,1); 
bar(0:length(tongji1)-1,tongji1);
title(['��һ���ȴ��ӳ��ֲ�','������1=',num2str(Mu1)]);
xlabel('�ӳ�'); ylabel('��ʱ��');
%�ڶ���
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
title(['�ڶ����ȴ��ӳ��ֲ�','������2=',num2str(Mu2)]);
xlabel('�ӳ�'); ylabel('��ʱ��');
disp(['�ڶ���ƽ���ȴ��ӳ�����ֵ=',num2str(meanWaitQueue2)]);
%�ܶӳ�
meanWaitQueue3=sum(waitTime3(:,1).*waitTime3(:,2))/endTime;
disp(['��ƽ���ȴ��ӳ�����ֵ=',num2str(meanWaitQueue3)]);
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
title('�ܵȴ��ӳ��ֲ�');
xlabel('�ӳ�'); ylabel('��ʱ��');
%======================================================
