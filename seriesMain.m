

%���ɶ���������
Lambda=input("�����뵽�ﲴ����������=");%��
Mu1=input("�������һ�������¼���ָ���ֲ�������1=");%��
Mu2=input("������ڶ��������¼���ָ���ֲ�������2=");%��

%initialization
queueLength1=0;%��һ���ȴ��ӳ�
queueLength2=0;%�ڶ����ȴ��ӳ�

agentStates1=0;%��һ��0�޷���1������
agentStates2=0;%�ڶ���0�޷���1������

time=0.0;%��ǰʱ��
endTime=10000.0;%����ʱ��
nextEvent=[endTime+1,endTime+1,endTime+1];%{��һ���˿͵���ʱ�䣬��һ����һ���������ʱ��,�ڶ�����һ���������ʱ��}
nextEventKind=1;%��һ���¼�����1�˿͵��2��һ���������,3�ڶ����������

[s1,s2,s3] = RandStream.create('mrg32k3a','NumStreams',3);
r1 = "-log(rand(s1))/Lambda";
r2 = "-log(rand(s2))/Mu1";
r3 = "-log(rand(s2))/Mu2";

%������
while(time<endTime)
    switch nextEventKind
    case 1
        %clientComingEvent
        nextEvent(1)=time + eval(r1);
        if(queueLength1>0 || agentStates1==1)
            queueLength1=queueLength1+1;
        else
            agentStates1=1;
            nextEvent(2)=time +eval(r2);
        end
    case 2
        %serve1ClientEndEvent
        if(queueLength1>0)
            queueLength1=queueLength1-1;
            nextEvent(2)=time + eval(r2);
        else
            agentStates1=0;
            nextEvent(2)=endTime+1;
        end
        
        if(queueLength2>0 || agentStates2==1)
            queueLength2=queueLength2+1;
        else
            agentStates2=1;
            nextEvent(3)=time +eval(r3);
        end
    case 3
         %serve2ClientEndEvent
         if(queueLength2>0)
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
disp("���")
