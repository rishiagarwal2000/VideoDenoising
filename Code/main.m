% Code for running experiments
clc;clear;
addpath(genpath('MMread'));
K = 20;
start = 1;
vid = mmread('../Data/carphone_qcif.y4m', start:start+K, [], false, true);
H = 32;%vid.height;
W = 32;%vid.width; 
px = 8; py = 8;
rec = zeros(H,W,3,K); count = 0.0001*ones(H,W,3,K); kappa = 0.4;
%temp1 = vid.frames(4).cdata; temp1 = temp1(50:50+H-1,70:70+W-1,:); imshow(temp1); drawnow;
%figure;
for iter = 1:K
    temp = double(vid.frames(iter).cdata);
    data(:,:,:,iter) = temp(50:50+H-1,70:70+W-1,:); %imshow(data(:,:,:,iter)/255); drawnow; pause(2);
    meas(:,:,:,iter) = data(:,:,:,iter)+10*randn(H,W,3)+poissrnd(kappa*data(:,:,:,iter),H,W,3)-kappa*data(:,:,:,iter);
end

%let 5 closest patches in each frame be pre decided.(Work on this algorithm next!!)
for x = 2:H-px
    x
    for y = 2:W-py
        %p = meas(x:x+px-1,y:y+py-1,:,k);
        if x > 1 && y > 1
            A = reshape(meas(x-1:x-1+px-1,y:y+py-1,:,:),3*px*py,K);
            B = reshape(meas(x+1:x+1+px-1,y:y+py-1,:,:),3*px*py,K);
            C = reshape(meas(x:x+px-1,y-1:y-1+py-1,:,:),3*px*py,K);
            D = reshape(meas(x:x+px-1,y+1:y+1+py-1,:,:),3*px*py,K);
            E = reshape(meas(x:x+px-1,y:y+py-1,:,:),3*px*py,K);
            mat = [A,B,C,D,E];
            ans = fpi(mat);
            %ans = fpi(E);
            A = ans(:,1:K); B = ans(:,K+1:2*K); C = ans(:,2*K+1:3*K); D = ans(:,3*K+1:4*K); E = ans(:,4*K+1:5*K);
            rec(x-1:x-1+px-1,y:y+py-1,:,:) = rec(x-1:x-1+px-1,y:y+py-1,:,:) + reshape(A,px,py,3,K);
            count(x-1:x-1+px-1,y:y+py-1,:,:) = count(x-1:x-1+px-1,y:y+py-1,:,:) + ones(px,py,3,K);
            rec(x+1:x+1+px-1,y:y+py-1,:,:) = rec(x+1:x+1+px-1,y:y+py-1,:,:) + reshape(B,px,py,3,K);
            count(x+1:x+1+px-1,y:y+py-1,:,:) = count(x+1:x+1+px-1,y:y+py-1,:,:) + ones(px,py,3,K);
            rec(x:x+px-1,y-1:y-1+py-1,:,:) = rec(x:x+px-1,y-1:y-1+py-1,:,:) + reshape(C,px,py,3,K);
            count(x:x+px-1,y-1:y-1+py-1,:,:) = count(x:x+px-1,y-1:y-1+py-1,:,:) + ones(px,py,3,K);
            rec(x:x+px-1,y+1:y+1+py-1,:,:) = rec(x:x+px-1,y+1:y+1+py-1,:,:) + reshape(D,px,py,3,K);
            count(x:x+px-1,y+1:y+1+py-1,:,:) = count(x:x+px-1,y+1:y+1+py-1,:,:) + ones(px,py,3,K);
            rec(x:x+px-1,y:y+py-1,:,:) = rec(x:x+px-1,y:y+py-1,:,:) + reshape(E,px,py,3,K);
            count(x:x+px-1,y:y+py-1,:,:) = count(x:x+px-1,y:y+py-1,:,:) + ones(px,py,3,K);
        end
    end
end
rec = rec./count;
figure;
subplot(3,1,3);imshow(rec(:,:,:,4)/255);
subplot(3,1,1);imshow(data(:,:,:,4)/255);
subplot(3,1,2);imshow(meas(:,:,:,4)/255);