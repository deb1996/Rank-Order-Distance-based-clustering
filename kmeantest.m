clc;
clear all;
database=dir('C:\Users\user\Desktop\detectedface\*.pgm');
g=length(database);
%g=5;
disp(g);
z=1;
features=zeros(257,100);
%extracting feature vectors
for count=1:g  
   fname=strcat('C:\Users\user\Desktop\detectedface\',database(count).name);
    [pixelCounts]=LBPnew(fname);
    features(2:257,z)=pixelCounts(:,1);
    z=z+1;
    %fprintf('size of the features %d\n',size(features,1)-1);   
end
%disp(features(:,[1,2,3,4,5,6,7,8,9,10]));
%calculate distance vector for each image

distance1=zeros(100,100);
dlmwrite('featuresFile.txt',features);
k=12;
[cluster,codebook]=kmeans(features,12,0.3);
fprintf('the codebook info is');
disp(codebook);
%disp(cluster);
fprintf('the cluster info\n');
%disp(codebook);
clustermat=zeros(k,100);
for i=1:k
    [row,colindex]=find(cluster==i);
    len=size(colindex,2);
    clustermat(i,1:len)=colindex(1,1:len);
    clustermat(i,100)=len;
end
plotcluster(k,clustermat);

