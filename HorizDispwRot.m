%% Horizontal Displacement with Rotation
clear all; close all; clc;

load('camera_data/cam1_4.mat');
cam1 = double(vidFrames1_4);

load('camera_data/cam2_4.mat');
cam2 = double(vidFrames2_4);

load('camera_data/cam3_4.mat');
cam3 = double(vidFrames3_4);

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
    mov1(k).cdata = vidFrames1_4(:,:,:,k);
    mov1(k).colormap = [];
    cam1g(:,:,k) = rgb2gray(vidFrames1_4(:,:,:,k));
end
for k = 1:numFrames2
    mov2(k).cdata = vidFrames2_4(:,:,:,k);
    mov2(k).colormap = [];
    cam2g(:,:,k) = rgb2gray(vidFrames2_4(:,:,:,k));
end
for k = 1:numFrames3
    mov3(k).cdata = vidFrames3_4(:,:,:,k);
    mov3(k).colormap = [];
    cam3g(:,:,k) = rgb2gray(vidFrames3_4(:,:,:,k));
end

%% Creating movies 

figure(1)
for i = 1:min(frames)  
    subplot(1,3,1) % i = 15 at peak
    F1 = frame2im(mov1(i + 15));
    imshow(F1);
    drawnow
    
    subplot(1,3,2) % i = 19 at peak
    F2 = frame2im(mov2(i + 19));
    imshow(F2);
    drawnow
    
    subplot(1,3,3) % i = 16 at peak
    F3 = frame2im(mov3(i + 16));
    imshow(F3);
    drawnow
end

%% Synchronizing the movie files 
% reset movie files so they are all synchronized
mov1_disp = 15 + 1;
mov2_disp = 19 + 1;
mov3_disp = 16 + 1;

cam1g = cam1g(:,:,mov1_disp:end);
cam2g = cam2g(:,:,mov2_disp:end);
cam3g = cam3g(:,:,mov3_disp:end);

numFrames1 = size(cam1g,3);
numFrames2 = size(cam2g,3);
numFrames3 = size(cam3g,3);

frames = [numFrames1, numFrames2, numFrames3];
shortest = min(frames);

%% getting the positions for the first camera
figure()
x1 = zeros(1,numFrames1);
y1 = zeros(1,numFrames1);
for i = 1:numFrames1
    frame = cam1g(:,:,i);
    subplot(1,2,1)
    imshow(uint8(frame))
    subplot(1,2,2)
    width = 150;
    filt = zeros(ydim,xdim);
    filt(150:end,300:300+width) = frame(150:end,300:300+width);
    maxf = max(filt(:));
    filt(filt < maxf) = 0;
    imshow(uint8(filt))
    drawnow
    [y1(i),x1(i)] = ind2sub(size(filt),find(filt == maxf,1));
end

%% getting the positions for the second camera
figure()
x2 = zeros(1,numFrames2);
y2 = zeros(1,numFrames2);
for i = 1:numFrames2
    frame = cam2g(:,:,i);
    subplot(1,2,1)
    imshow(uint8(frame))
    subplot(1,2,2)
    filt = frame;
    maxf = max(filt(:));
    filt(filt < maxf) = 0;
    imshow(uint8(filt))
    drawnow
    [y2(i),x2(i)] = ind2sub(size(filt),find(filt == maxf,1));
end

%% getting the positions for the third camera
figure()
x3 = zeros(1,numFrames3);
y3 = zeros(1,numFrames3);
for i = 1:numFrames3
    frame = cam3g(:,:,i);
    subplot(1,2,1)
    imshow(uint8(frame));
    subplot(1,2,2)
    filt = frame;
    maxf = max(filt(:));
    filt(filt<maxf) = 0;
    imshow(uint8(filt))
    drawnow
    [y3(i),x3(i)] = ind2sub(size(filt),find(filt == maxf,1));
end

%% Prep the matrix for the SVD
x1 = x1(1:shortest);
y1 = y1(1:shortest);
x2 = x2(1:shortest);
y2 = y2(1:shortest);
x3 = x3(1:shortest);
y3 = y3(1:shortest);

X = [x1;y1;x2;y2;x3;y3];
[u,s,v] = svd(X);
lambda = diag(s).^2;
Y = u'*X;

Cx = cov(X');

figure()
plot(diag(Cx))
xlabel('Elements')
ylabel('Covariances')
title('Diagonal Elements of the Covariance Matrix in Horizontal Disp w/ Rotation Case')

%% Playing with the SVD
figure()
sig = diag(s);

title('Singular Values and PCA Modes for Hoizontal Disp w/ Rot Case')
sig=diag(s);
subplot(3,2,1), plot(sig,'ko','Linewidth',[1.5])
axis([0 7 0 2*10^4])
set(gca,'Fontsize',[13],'Xtick',[0 1 2 3 4 5 6]) 
text(6,1.75*10^4,'(a)','Fontsize',[13])

subplot(3,2,2), semilogy(sig,'ko','Linewidth',[1.5])
axis([0 7 0 2*10^4])
set(gca,'Fontsize',[13],'Ytick',[10^0 10^2 10^3 10^4 10^5],...
   'Xtick',[0 1 2 3 4 5 6]); 
text(6,1.4*10^4,'(b)','Fontsize',[13])

xtest = linspace(1,6,6);
subplot(3,1,2) 
plot(xtest,u(:,1),'k',xtest,u(:,2),'k--',xtest,u(:,3),'k:','Linewidth',[2]) 
set(gca,'Fontsize',[13])
legend('mode 1','mode 2','mode 3','Location','NorthWest') 
text(5.75,0.5,'(c)','Fontsize',[13])

subplot(3,1,3)
t = linspace(1,shortest,shortest);
plot(t, v(:,1),'k',t, v(:,2),'k--',t, v(:,3),'k:','Linewidth',[2])
legend('mode 1','mode 2','mode 3','Location','NorthWest') 
axis([0 numFrames1 -0.1 0.2])
text(355,0.15,'(d)','Fontsize',[13])