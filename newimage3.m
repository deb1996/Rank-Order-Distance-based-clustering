clc;
clear all;
database=dir('C:\Users\user\Desktop\detectedface\*.pgm');
g=length(database);
disp(g);
z=1;
features=zeros(257,100);
%extracting feature vectors
for count=1:g  
   fname=strcat('C:\Users\user\Desktop\detectedface\',database(count).name);
    features(1,z)=z;
    [pixelCounts]=LBPnew(fname);
    features(2:257,z)=pixelCounts(:,1);
    z=z+1;   
end
%calculate distance vector for each image
distance1=zeros(100,100);
dlmwrite('featuresFile.txt',features);
distance1=cal_distance(features,distance1);
dlmwrite('distanceFile.txt',distance1);
%finding rank of the images with respect to a particular image
rank=zeros(100,100);
for i=1:100
    actual=distance1(:,i);
    dummy=distance1(:,i);
    dummy=sort(dummy,1);  
    for j=1:100
        [r,c]=find(dummy==actual(j,1));
        temp=r(1,1);
        rank(temp,i)=j;
        dummy(temp,1)=-1;
    end
end
fprintf('the rank of images\n');
%disp(rank);
dlmwrite('rankFile.txt',rank);
[row,col]=size(rank);
fprintf('size of rank %d %d',row,col);
%finding rank order distance
rank_order_distance=zeros(100,100);
for k=1:100
    dummy2=rank(:,k);
    for j=1:100
        dummy3=rank(:,j);
        if(k==j)
            continue;
        end
        [t1,t2]=find(dummy2==j);
        if(isempty(t1))
            fprintf('not found %d j in %d k\n',j,k);
        else   
            for h=1:t1
                [fnd,cnd]=find(dummy3==dummy2(h,1));
                if(isempty(fnd))
                   fprintf('not found %d in %d vector for vector %d\n',h,j,k);
                else   
                fnd=fnd-1;   
                rank_order_distance(j,k)=rank_order_distance(j,k)+fnd;
                end
            end
        end
        
    end
end
fprintf('rank order distance \n');
%finding normalised rank order distance
normalised_rank_order_distance=zeros(100,100);
for k=1:100
     dummyk=rank(:,k);
    for j=1:100
     sum=rank_order_distance(j,k)+rank_order_distance(k,j);
     dummyj=rank(:,j);
     [j_in_k,cj]=find(dummyk==j);
     [k_in_j,ck]=find(dummyj==k);
     divisor=k_in_j;
     if(j_in_k<k_in_j)
         divisor=j_in_k;
     end
    normalised_rank_order_distance(j,k)=sum/divisor;
    end
end
fprintf('normalised distance between two pair of images\n');
dlmwrite('myFile.txt',normalised_rank_order_distance,'delimiter','\t','precision',3);
disp(normalised_rank_order_distance);
[class,type,clustermat,no]=dbscandistance(normalised_rank_order_distance,6,30);
%disp(clustermat);
clustermat=eliminateduplicate(clustermat,no-1,normalised_rank_order_distance);
%{
disp(clustermat);
fprintf('cluster info\n');
disp(class);
fprintf('type of the data\n\n');
disp(type);
[row,indexzero]=find(type==(-1));
len=size(indexzero,2);
disp(len);
for i=1:len
    closedcluster=zeros(1,no-1);
    for j=1:no-1
        col=clustermat(j,100);
        temp=clustermat(j,1:col);
        len2=size(temp,2);
        %disp(len2);
        %distance=zeros(1,len2);
        distance=0;
        %t=1;
        for k=1:len2
            r=indexzero(1,i);
            c=temp(1,k);
            distance=distance+normalised_rank_order_distance(r,c);
            %t=t+1;
        end
        closedcluster(1,j)=distance;
    end
    closedcluster1=closedcluster(1,:);
    %clustermat=noisehandle(closedcluster1,clustermat,i,indexzero);
    added=0;
    while(added==0)
        mindis=min(closedcluster);
        [row,index]=find(closedcluster(1,:)==mindis);
        col=clustermat(index,100);
        col=col+1;
        if (col<=10)
            fprintf('added %d in the row %d and %d col\n',indexzero(1,i),index,col);
            clustermat(index,100)=col;
            clustermat(index,col)=indexzero(1,i);
            fprintf('after addition col %d\n',clustermat(index,100));
            added=1;
        else
       % fprintf('col exceeds for %d\n',indexzero(1,i));
            closedcluster(index)=40000.0;
        end
    end
end
fprintf('the cluster matrix\n');
disp(clustermat);
%}
plotcluster(no-1,clustermat);
%calculating compression ratio
total=0;
for i=1:no-1
    total=total+clustermat(i,100);
end
R=total/(no-1);
fprintf('the value of compression ratio is %f\n',R);
%calculating recall
F=100;
totalnoise=0;
totalfaces=total;
R=totalfaces/F;
fprintf('the recall for the oral database is %f\n',R);