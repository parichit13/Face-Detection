close all;
clear all;
clc;
scale = [355, 270];
rgbInputImage = imread('chinesecouple.jpg');
rgbInputImage = imresize(rgbInputImage,scale);
%rgbInputImage=getsnapshot(rgbInputImage);
labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
figure, imshow(rgbInputImage);hold on
title('Original Image');
hold off;
figure, imshow(rgbOutputImage);hold on
title('Histogram Equalization');
hold off;
img=rgbOutputImage;
final_image = zeros(size(img,1), size(img,2));
if(size(img, 3)>1)
for i = 1:size(img,1)
for j = 1:size(img,2)
R = img(i,j,1);
G = img(i,j,2);
B = img(i,j,3);
if(R > 92 && G > 40 && B > 20)
v = [R,G,B];
if((max(v)-min(v))>15)
if(abs(R-G) > 15 && R > G && R > B)
%it is a skin
final_image(i,j) = 1;
end
end
end
end
end
%Grayscale To Binary.
binaryImage=im2bw(final_image,0.6);
figure, imshow(binaryImage); hold on
title('Skin Detection and Segmentation');
hold off;

%Filling The Holes.
binaryImage = imfill(binaryImage, 'holes');
figure, imshow(binaryImage); hold on
title('Filling the holes');
hold off;
binaryImage = bwareaopen(binaryImage,1890);   
figure,imshow(binaryImage),title('Threshold image');
labeledImage = bwlabel(binaryImage, 8);
figure,imshow(labeledImage);
blobMeasurements = regionprops(labeledImage, final_image, 'all');
numberOfPeople = size(blobMeasurements, 1)
figure,imagesc(rgbInputImage); title('Outlines, from bwboundaries()'); 
%axis square;
hold on;
boundaries = bwboundaries(binaryImage);
for k = 1 : numberOfPeople
thisBoundary = boundaries{k};
plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
% hold off;


figure, imshow(rgbInputImage);
hold on;
title('Final Image with bounding boxes');
%fprintf(1,'Blob # x1 x2 y1 y2\n');
for k = 1 : numberOfPeople % Loop through all blobs.
% Find the mean of each blob. (R2008a has a better way where you can pass the original image
% directly into regionprops. The way below works for all versionsincluding earlier versions.)
thisBlobsBox = blobMeasurements(k).BoundingBox; % Get list of pixels in current blob.
rectangle('Position',thisBlobsBox,'EdgeColor','B','LineWidth',2);
end

peaksnr = PSNR(binaryImage,rgbInputImage)


%figure, imshow(labeledImage);
%B = bwboundaries(binaryImage);
%imshow(B);
%text(10,10,strcat('\color{green}Objects Found:',num2str(length(B))))
%hold on
%for k = 1:length(B)
%boundary = B{k};
%plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 0.2)
%end
end
