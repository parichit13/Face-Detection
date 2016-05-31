clear all
clc
%stats = profile('info'); 
scale = [355, 270]
%Initialize the Viola Jones Face Detector
FDetect = vision.CascadeObjectDetector();

I = imread('sample13.jpg');
%I = imrotate(I,270);
I = imresize(I,scale);
figure,imshow(I);
%Pass the input image to the detector via step function
BB = step(FDetect,I)
figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;
%stats.FunctionTable(2);