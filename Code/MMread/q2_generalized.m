addpath(genpath('MMread'));
T = 3;
start = 4;
vid = mmread('../flame.avi', start:start+T, [], false, true);
H = vid.height;
W = vid.width;
newH = 150; newW = 240;
frame = cell(T,1);finalImage = cell(T,1);
I = zeros(newH,newW);
%%%% Extract frames
for iter = 1:T
frame{iter} = double(rgb2gray(vid.frames(iter).cdata));
frame{iter} = frame{iter}(H-newH+1:H,W-newW+1:W);
C{iter} = randi([0 1], newH,newW);
finalImage{iter} = zeros(newH, newW);
I = I + C{iter}.*frame{iter};
end
%%%% Generate random code

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
D = kron(eye(T), D');
%finalImage1 = zeros(newH, newW); finalImage2 = zeros(newH, newW); finalImage3 = zeros(newH, newW);
counter = ones(newH, newW)*0.0001;
xIdxs = [1:patchSz(2):imSz(2) imSz(2)+1];
yIdxs = [1:patchSz(1):imSz(1) imSz(1)+1];
patches = cell(length(yIdxs)-1,length(xIdxs)-1);
Csub = cell(T,1);Csubf = cell(T,1);
d = cell(T,1);
for i = 1:newH-patchSz(1)+1
    %print = i
    Isub =  I(i:i+patchSz(1)-1,:);
	for iter = 1:T
    Csub{iter} = C{iter}(i:i+patchSz(1)-1,:);
    end
    for j = 1:newW-patchSz(2)+1
        Isubf = Isub(:,j:j+patchSz(2)-1);
    	for iter = 1:T
    	Csubf{iter} = Csub{iter}(:,j:j+patchSz(2)-1);
        d{iter} = diag(Csubf{iter}(:));
        end
        %print = j
        Asub = horzcat(d{:})*D;
        bsub = Isubf(:);
        % Apply OMP
%========================================================%
%%%%%%%%%%%%%%%% HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        c = 1;
        Asubnorm = normc(Asub);
        err = 1.5*(patchSz(2)*patchSz(1))^(0.5)*sigma;
        r = bsub; theta = zeros(T*patchSz(2)*patchSz(1),1); t = [];
        while (norm(r)>err)
            ar = Asubnorm'*r;
            [a, k] = max(abs(ar));
            t = union(t, [k]);
            theta(t) = pinv(Asub(:,t))*bsub;
            r = bsub - Asub(:,t)*theta(t);
            %norm(r)
        end
        xsub = D*theta;
        counter(i:i+patchSz(1)-1,j:j+patchSz(2)-1) = counter(i:i+patchSz(1)-1,j:j+patchSz(2)-1) + ones(patchSz(1),patchSz(2));
        for iter=1:T
        finalImage{iter}(i:i+patchSz(1)-1,j:j+patchSz(2)-1) = finalImage{iter}(i:i+patchSz(1)-1,j:j+patchSz(2)-1)+reshape(xsub(1+(iter-1)*patchSz(2)*patchSz(1):(iter)*patchSz(2)*patchSz(1)), patchSz(1),patchSz(2));
   		end
    end
end
for iter = 1:T
finalImage{iter} = finalImage{iter}./counter;
end
figure;
for iter = 1:T
subplot(2,T,iter);imshow(frame{iter},[]);
end
for iter = 1:T
subplot(2,T,iter+T);imshow(finalImage{iter},[]);
end