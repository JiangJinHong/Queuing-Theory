Lambada=20;
Mu1=30;
Mu2=35;
[s1,s2,s3] = RandStream.create('mrg32k3a','NumStreams',3);
r1 = -log(rand(s1,100000,1))/Lambada;
r2 = -log(rand(s2,100000,1))/Mu1;
r3 = -log(rand(s3,100000,1))/Mu2;
hist(r1,100);
figure;
hist(r2,100);
figure;
hist(r3,100);
