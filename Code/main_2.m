% Code for running experiments
clc;clear;
addpath(genpath('MMread'));
K = 20;
start = 1;
vid = mmread('../Data/carphone_qcif.y4m', start:start+K, [], false, true);
H = 50;%vid.height;
W = 50;%vid.width; 
px = 8; py = 8;
rec = zeros(H,W,3,K); count = 0.0001*ones(H,W,3,K); kappa = 0.4;
%temp1 = vid.frames(4).cdata; temp1 = temp1(50:50+H-1,70:70+W-1,:); imshow(temp1); drawnow;
%figure;
for iter = 1:K
    temp = double(vid.frames(iter).cdata);
    data(:,:,:,iter) = temp(35:35+H-1,55:55+W-1,:); %imshow(data(:,:,:,iter)/255); drawnow; pause(2);
    meas(:,:,:,iter) = data(:,:,:,iter)+10*randn(H,W,3)+poissrnd(kappa*data(:,:,:,iter),H,W,3)-kappa*data(:,:,:,iter);
end

%let 5 closest patches in each frame be pre decided.(Work on this algorithm next!!)
for iter = 1:K
    iter
    for x = 1:H-px+1
        x
        for y = 1:W-py+1
        %p = meas(x:x+px-1,y:y+py-1,:,k);
            [mat, loc] = basicPM([x,y,iter],meas,4,5,px,py);
            svt = fpi(mat);
            %ans = fpi(E);
            for it = 1:5*K
                curx = loc(1,it); cury = loc(2,it); curf = loc(3,it);
                curPat = reshape(svt(:,it),px,py,3);
                rec(curx:curx+px-1,cury:cury+py-1,:,curf) = rec(curx:curx+px-1,cury:cury+py-1,:,curf) + curPat;
                count(curx:curx+px-1,cury:cury+py-1,:,curf) = count(curx:curx+px-1,cury:cury+py-1,:,curf) + ones(px,py,3);
            end
        end
    end
    recTemp = rec./count;
    figure;
    subplot(3,1,3);imshow(recTemp(:,:,:,iter)/255);
    subplot(3,1,1);imshow(data(:,:,:,iter)/255);
    subplot(3,1,2);imshow(meas(:,:,:,iter)/255);
    drawnow;
end
rec = rec./count;
figure;
subplot(3,1,3);imshow(rec(:,:,:,4)/255);
subplot(3,1,1);imshow(data(:,:,:,4)/255);
subplot(3,1,2);imshow(meas(:,:,:,4)/255);