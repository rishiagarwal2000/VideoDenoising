% Code for adding noise

function noised = mynoise(im,sigma,kappa,s)
    % s is the probability of an impulsive noise
    % kappa decides the amount of Poisson noise
    % sigma is the std of Gaussian noise
    H = size(im,1); W = size(im,2);
    I = rand(H,W);
    for lambda = 1:3
       curIm = im(:,:,lambda);
       temp = curIm;
       impulse = 255.0*randi([0 1],H,W);
       gaus = sigma*randn(H,W); 
       pos = poissrnd(kappa*curIm,H,W) - kappa*curIm;
       temp(I>s) = curIm(I>s) + gaus(I>s) + pos(I>s);
       temp(I<=s) = impulse(I<=s);
       noised(:,:,lambda) = temp;
    end
end
