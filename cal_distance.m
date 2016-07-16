function [ distance1 ] = cal_distance(features,distance1)
%CAL_DISTANCE Summary of this function goes here
%   Detailed explanation goes here

for i=1:100
    k=1;
   while(i>k)
       distance1(k,i)=distance1(i,k);
       k=k+1;
   end
   if(i==k)
       distance1(i,k)=0;
       k=k+1;
   end
   veci=features(:,i);
   vecii=veci(2:257);
   while(k<=100)
   veck=features(:,k);
   veckk=veck(2:257);
   %calculation of distance between two features vectors
   dis=sqrt(sum((vecii-veckk).^2));
  % V=vecii-veckk;
   %dis= sqrt(V * V');
   distance1(k,i)=dis;%copy distance
   k=k+1;
   end     
end

