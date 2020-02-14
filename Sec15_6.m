clear all; close all; clc

% Here the optimization routine is added to the path:
base    = pwd;
folder1 = 'inexact_alm_rpca';
folder2 = 'inexact_alm_rpca/PROPACK';
addpath(fullfile(base,folder1));
addpath(fullfile(base,folder2));

n=200;
x=linspace(-10,10,n);
t=linspace(0,10,30);
[X,T]=meshgrid(x,t); 
usol=sech(X).*(1-0.5*cos(2*T))+(sech(X).*tanh(X)).*(1-0.5*sin(2*T)); 
subplot(2,2,1), waterfall(x,t,abs(usol)); colormap([0 0 0]);

sam=60;
Atest2=zeros(length(t),n); 
Arand1=rand(length(t),n); 
Arand2=rand(length(t),n);
r1 = randperm(length(t)*n);
r1k= r1(1:sam);
for j=1:sam 
    Atest2(r1k(j))=-1;
end
Anoise=Atest2.*(Arand1+i*Arand2);
unoise=usol+2*Anoise;
subplot(2,2,2), waterfall(x,t,abs(unoise)); colormap([0 0 0]);

A1=usol; A2=unoise; 
[U1,S1,V1]=svd(A1); 
[U2,S2,V2]=svd(A2);

figure(2)
ur=real(unoise); ui=imag(unoise);
lambda=0.2; 
[R1r,R2r]=inexact_alm_rpca(real(ur.'),lambda); 
[R1i,R2i]=inexact_alm_rpca(real(ui.'),lambda);
  R1=R1r+i*R1i;
  R2=R2r+i*R2i;
[U3,S3,V3]=svd(R1.');
subplot(2,2,1), waterfall(x,t,abs(R1)'), colormap([0 0 0]) 
subplot(2,2,2), waterfall(x,t,abs(R2)'), colormap([0 0 0])

%% LOW RANK APPROXIMATIONS

figure(3)
% low-rank approximation of corrupt data matrix 
for jj=1:4
 for j=1:jj+1
  ff=U2(:,1:j)*S2(1:j,1:j)*V2(:,1:j).';
  subplot(2,2,jj), waterfall(x,t,abs(ff)), colormap([0 0 0])
 end
end

% approximation of low-rank matrix from robust PCA
figure(4)
for jj=1:4
  for j=1:jj+1
    ff=U3(:,1:j)*S3(1:j,1:j)*V3(:,1:j).';
    subplot(2,2,jj), waterfall(x,t,abs(ff)), colormap([0 0 0]) 
  end
end