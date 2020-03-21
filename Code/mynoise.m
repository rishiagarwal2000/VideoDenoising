% Code for adding noise

function noised = mynoise(im,sigma,kappa,s)
    H = size(im,1); W = size(im,2);
    %{
    I = rand(H,W);
    noised = im; gaus = sigma*randn(H,W,3); pos = poissrnd(kappa*im,H,W,3) - kappa*im;
    noised(I>s) = im(I>s) + gaus(I>s) + pos(I>s);
    noised(I<=s & I>s/2) = 255;
    noised(I<=s/2) = 0;
    %}
    I = rand(H,W);
    for lambda = 1:3
       curIm = im(:,:,lambda); impulse = 255.0*randi([0 1],H,W);
       temp = curIm; gaus = sigma*randn(H,W); pos = poissrnd(kappa*curIm,H,W) - kappa*curIm;
       temp(I>s) = curIm(I>s) + gaus(I>s) + pos(I>s);
       temp(I<=s) = impulse(I<=s);
       noised(:,:,lambda) = temp;
    end
end