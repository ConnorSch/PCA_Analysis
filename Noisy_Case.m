%% Ideal Case for Cameras
clear all; close all; clc;

load('camera_data/cam1_2.mat');
cam1 = double(vidFrames1_2);

load('camera_data/cam2_2.mat');
cam2 = double(vidFrames2_2);

load('camera_data/cam3_2.mat');
cam3 = double(vidFrames3_2);

numFrames1 = size(cam1,4);
numFrames2 = size(cam2,4);
numFrames3 = size(cam3,4);

frames = [numFrames1, numFrames2, numFrames3];

xdim = size(cam1,2);
x = linspace(1,xdim,xdim);
ydim = size(cam1,1);
y = linspace(1,ydim,ydim);

cam1g = zeros(ydim, xdim, numFrames1);
cam2g = zeros(ydim, xdim, numFrames2);
cam3g = zeros(ydim, xdim, numFrames3);

for k = 1:numFrames1
    mov1(k).cdata = vidFrames1_2(:,:,:,k);
    mov1(k).colormap = [];
    cam1g(:,:,k) = rgb2gray(vidFrames1_2(:,:,:,k));
end
for k = 1:numFrames2
    mov2(k).cdata = vidFrames2_2(:,:,:,k);
    mov2(k).colormap = [];
    cam2g(:,:,k) = rgb2gray(vidFrames2_2(:,:,:,k));
end
for k = 1:numFrames3
    mov3(k).cdata = vidFrames3_2(:,:,:,k);
    mov3(k).colormap = [];
    cam3g(:,:,k) = rgb2gray(vidFrames3_2(:,:,:,k));
end

%% Creating movies 

figure(1)
for i = 1:numFrames1
    subplot(1,3,1)
    X = frame2im(mov1(i));
    imshow(X);
    drawnow
    
    subplot(1,3,2)
    X2 = frame2im(mov2(i));
    imshow(X2);
    drawnow
    
    subplot(1,3,3)
    X3 = frame2im(mov3(i));
    imshow(X3);
    drawnow
end