

%生成独立泊松流
Lambda=input("请输入到达泊松流参数λ=");%λ
Mu1=input("请输入第一级服务事件负指数分布参数μ1=");%μ
Mu2=input("请输入第二级服务事件负指数分布参数μ2=");%μ

%initialization
queueLength1=0;%第一级等待队长
queueLength2=0;%第二级等待队长

agentStates1=0;%第一级0无服务1服务中
agentStates2=0;%第二级0无服务1服务中

time=0.0;%当前时间
endTime=10000.0;%结束时间
nextEvent=[endTime+1,endTime+1,endTime+1];%{下一个顾客到达时间，第一级下一个服务结束时间,第二级下一个服务结束时间}
nextEventKind=1;%下一个事件类型1顾客到达，2第一级服务结束,3第二级服务结束

[s1,s2,s3] = RandStream.create('mrg32k3a','NumStreams',3);
r1 = "-log(rand(s1))/Lambda";
r2 = "-log(rand(s2))/Mu1";
r3 = "-log(rand(s2))/Mu2";

%主程序
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
disp("完成")
