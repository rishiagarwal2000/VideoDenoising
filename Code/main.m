% Code for running experiments
clc;clear;
K = 5;
start = 1;
vid = VideoReader('../Data/miss_am_qcif.y4m');
H = 64;
W = 64;
px = 8; py = 8;
sx = 35;%Calender_demo->135;20 
sy = 55;%Calender_demo->175;20
rec = zeros(H,W,3,K); count = 0.0001*ones(H,W,3,K); sigma = 10; kappa = 0.4; s = 0.4;   

for iter = 1:K
    temp = double(read(vid,start+iter-1));
    data(:,:,:,iter) = temp(sx:sx+H-1,sy:sy+W-1,:);
    measN(:,:,:,iter) = mynoise(data(:,:,:,iter),sigma,kappa,s);
    meas(:,:,:,iter) = admedfilt(measN(:,:,:,iter));
end

%Filter the central frame
iter = 3;
for x = 1:H-px+1
    x
    for y = 1:W-py+1
        [mat, loc] = basicPM([x,y,iter],meas,4,5,px,py);
        svt = fpi(mat);
        for it = 1:5*K
            curx = loc(1,it); cury = loc(2,it); curf = loc(3,it);
            curPat = reshape(svt(:,it),px,py,3);
            rec(curx:curx+px-1,cury:cury+py-1,:,curf) = rec(curx:curx+px-1,cury:cury+py-1,:,curf) + curPat;
            count(curx:curx+px-1,cury:cury+py-1,:,curf) = count(curx:curx+px-1,cury:cury+py-1,:,curf) + ones(px,py,3);
        end
    end
end
recTemp = rec./count;

% Display the images
figure;
subplot(2,2,1);imshow(measN(:,:,:,iter)/255);title('a')
subplot(2,2,2);imshow(meas(:,:,:,iter)/255);title('b')
subplot(2,2,3);imshow(recTemp(:,:,:,iter)/255);title('c')
subplot(2,2,4);imshow(data(:,:,:,iter)/255);title('d')

% Display the stats
for_noisy = psnr(measN(:,:,:,1),data(:,:,:,1),255);
for_med_filt = psnr(meas(:,:,:,1),data(:,:,:,1),255);
for_fpi = psnr(recTemp(:,:,:,1),data(:,:,:,1),255);
stats = [for_noisy, for_med_filt, for_fpi]
drawnow;
rec = rec./count;
