clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
database=dir('C:\Users\user\Desktop\s23\*.pgm');
basepath ='C:\Users\user\Desktop\temp3\'; 
%I = imread('HarryPotter.jpg');
for count=1:10
fname=strcat('C:\Users\user\Desktop\s23\',database(count).name);
I=imread(fname);
%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);
disp(BB);
%imshow(I); hold on
%for i = 1:size(BB,1)
 %   t=rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
%end
%disp(t);
cropped = cell(1,1);
cropped{1} = imcrop(I,BB(1,:));
crp = cropped{1};
imwrite(crp, strcat(basepath,database(count).name),'pgm');
imshow(crp);
title('Face Detection');
end
