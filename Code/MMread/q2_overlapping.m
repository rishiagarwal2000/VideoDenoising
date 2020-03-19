T = 3;
vid = mmread('../cars.avi', 1:T, [], false, true);
H = vid.height;
W = vid.width;
newH = 120; newW = 240;
%%%% Extract frames
frame1 = double(rgb2gray(vid.frames(1).cdata));
frame2 = double(rgb2gray(vid.frames(2).cdata));
frame3 = double(rgb2gray(vid.frames(3).cdata));
frame1 = frame1(H-newH+1:H,W-newW+1:W);frame2 = frame2(H-newH+1:H,W-newW+1:W);frame3 = frame3(H-newH+1:H,W-newW+1:W);
%%%% Generate random code

C1 = randi([0 1], newH,newW);
C2 = randi([0 1], newH,newW);
C3 = randi([0 1], newH,newW);

%%%% Find sum
I = C1.*frame1+C2.*frame2+C3.*frame3;

%%%% Add error
sigma = 2;
I = I + sigma*randn(newH,newW);
figure;
imshow(I,[]);

%%%% Find A, b
%b = I(:);
%A = diag([C1(:);C2(:);C3(:)]);

%%%% OMP using 2D dct basis
imSz = size(I);
patchSz = [8 8];
D = kron(dctmtx(patchSz(2)), dctmtx(patchSz(1)));
D = blkdiag(D',D',D');
finalImage1 = zeros(newH, newW); finalImage2 = zeros(newH, newW); finalImage3 = zeros(newH, newW);
counter = ones(newH, newW)*0.0001;
xIdxs = [1:patchSz(2):imSz(2) imSz(2)+1];
yIdxs = [1:patchSz(1):imSz(1) imSz(1)+1];
patches = cell(length(yIdxs)-1,length(xIdxs)-1);
for i = 1:newH-patchSz(1)+1
    Isub =  I(i:i+patchSz(1)-1,:);
    C1sub = C1(i:i+patchSz(1)-1,:);
    C2sub = C2(i:i+patchSz(1)-1,:);
    C3sub = C3(i:i+patchSz(1)-1,:);
    for j = 1:newW-patchSz(2)+1
        Isubf = Isub(:,j:j+patchSz(2)-1);
        C1subf = C1sub(:,j:j+patchSz(2)-1);
        C2subf = C2sub(:,j:j+patchSz(2)-1);
        C3subf = C3sub(:,j:j+patchSz(2)-1);
        Asub = [diag(C1subf(:)),diag(C2subf(:)),diag(C3subf(:))]*D;
        bsub = Isubf(:);
        % Apply OMP
%========================================================%
%%%%%%%%%%%%%%%% HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        c = 1;
        Asubnorm = normc(Asub);
        err = (patchSz(2)*patchSz(1))^(0.5)*sigma;
        r = bsub; theta = zeros(3*patchSz(2)*patchSz(1),1); T = [];
        while (norm(r)>err)
            ar = Asubnorm'*r;
            [a, k] = max(abs(ar));
            T = union(T, [k]);
            theta(T) = pinv(Asub(:,T))*bsub;
            r = bsub - Asub(:,T)*theta(T);
            %norm(r)
        end
        xsub = D*theta;
        counter(i:i+patchSz(1)-1,j:j+patchSz(2)-1) = counter(i:i+patchSz(1)-1,j:j+patchSz(2)-1) + ones(patchSz(1),patchSz(2));
        finalImage1(i:i+patchSz(1)-1,j:j+patchSz(2)-1) = finalImage1(i:i+patchSz(1)-1,j:j+patchSz(2)-1)+reshape(xsub(1:patchSz(2)*patchSz(1)), patchSz(1),patchSz(2));
        finalImage2(i:i+patchSz(1)-1,j:j+patchSz(2)-1) = finalImage2(i:i+patchSz(1)-1,j:j+patchSz(2)-1)+reshape(xsub(1+patchSz(2)*patchSz(1):2*patchSz(1)*patchSz(2)), patchSz(1),patchSz(2));
        finalImage3(i:i+patchSz(1)-1,j:j+patchSz(2)-1) = finalImage3(i:i+patchSz(1)-1,j:j+patchSz(2)-1)+reshape(xsub(1+2*patchSz(2)*patchSz(1):3*patchSz(2)*patchSz(1)), patchSz(1),patchSz(2));
    end
end
finalImage1 = finalImage1./counter;finalImage2 = finalImage2./counter;finalImage3 = finalImage3./counter;
figure;
subplot(3,2,1);imshow(frame1,[]);
subplot(3,2,3);imshow(frame2,[]);
subplot(3,2,5);imshow(frame3,[]);
subplot(3,2,2); imshow(finalImage1, []);
subplot(3,2,4); imshow(finalImage2, []);
subplot(3,2,6); imshow(finalImage3, []);

