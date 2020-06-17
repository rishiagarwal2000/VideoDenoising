% Generate stats for adapt median filtering
clc;clear;
vid = VideoReader('../Data/miss_am_qcif.y4m');
sx = 35; sy = 55; H = 64; W = 64;
temp = double(read(vid,1));
temp = temp(sx:sx+H-1,sy:sy+W-1,:);
noisy = mynoise(temp,10,0.4,0.4);

wn = 3;
inbuilt_med(:,:,1) = medfilt2(noisy(:,:,1),[wn wn]);
inbuilt_med(:,:,2) = medfilt2(noisy(:,:,2),[wn wn]);
inbuilt_med(:,:,3) = medfilt2(noisy(:,:,3),[wn wn]);
%inbuilt_med = admedfilt(noisy);
adapt_med = admedfilt_2(noisy);

stats = [psnr(noisy,temp,255), psnr(inbuilt_med,temp,255), psnr(adapt_med,temp,255)]; 

stats

figure;
subplot(2,2,1);imshow(temp/255);title('a')
subplot(2,2,2);imshow(noisy/255);title('b')
subplot(2,2,3);imshow(inbuilt_med/255);title('c')
subplot(2,2,4);imshow(adapt_med/255);title('d')