% Main Algorithm
function [Q] = fpi(P)
    n_square = size(P,1); m = size(P,2);
    % Compute sigma
    M = mean(P,2); S = std(P,0,2); sigmaEst = mean(S);
    P_w = P; count = ones(n_square,m);
    P_cen = P - repmat(M,1,size(P,2));
    % Remove unreliable elements
    P_bool = abs(P_cen)-2*sigmaEst;
    P_w(P_bool>=0) = 0;
    count(P_bool>=0) = 0;
    % Compute sigma_hat
    M_w = sum(P_w,2)./sum(count,2);
    var_w = P_w - repmat(M_w,1,size(P,2));
    var_w = var_w.*var_w;
    var_w(P_bool>=0) = 0;
    sigma_hat_square = sum(sum(var_w))/sum(sum(count));
    % Compute 'p'
    p = sum(sum(count))/sum(sum(ones(n_square,m)));
    % Compute 'mu' using heuristics
    mu = (sqrt(n_square) + sqrt(m))*sqrt(p)*sqrt(sigma_hat_square);
    tau = 1.92; %choose appropriately
    % Perform iterations
    Qprev = ones(n_square,m);
    Qcur = zeros(n_square,m);
    iter = 0;
    epsilon = 1e-5;
    max_iter = 32;
    while (norm(Qcur-Qprev,'fro') > epsilon && iter < max_iter)
        Q_w = Qcur;
        Q_w(P_bool>=0) = 0;
        % Forward gradient step
        res = Qcur - tau*(Q_w-P_w);
        Qprev = Qcur;
        % Backward step (Proximal step)
        [U,S,V] = svd(res);
        Sch = S - tau*mu;
        Snew = max(Sch,0);
        Qcur = U*Snew*V';
        iter = iter + 1;
    end
    Q = Qprev;
end
