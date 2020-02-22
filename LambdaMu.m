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
title('��/��-ƽ���ӳ��仯ͼ');xlabel('��/��');ylabel('ƽ���ӳ�');
subplot(1,2,2);
plot(Lambda./Mu',finalClientTotalTime);
title('��/��-ƽ��ϵͳʱ��仯ͼ');xlabel('��/��');ylabel('ƽ��ϵͳʱ��');