Lambda=ones(10,1);
Mu=2:1:11;
for i=1:10
    for j=1:3
      [meanQueue(j,i),clientTotalTime(j,i)]=mainFunction(Lambda(i),Mu(i));
    end
end
finalMeanQueue=mean(meanQueue);
finalClientTotalTime=mean(clientTotalTime);
a=Lambda./Mu';

figure(1);
subplot(1,2,1);
plot(Lambda./Mu',finalMeanQueue);
title('λ/μ-平均队长变化图');xlabel('λ/μ');ylabel('平均队长');
subplot(1,2,2);
plot(Lambda./Mu',finalClientTotalTime);
title('λ/μ-平均系统时间变化图');xlabel('λ/μ');ylabel('平均系统时间');