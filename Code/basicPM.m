% Code for basic (exhaustive) patch matching

function [A,loc] = basicPM(p,meas,w,n,px,py)
    K = size(meas,4); H = size(meas,1); W = size(meas,2); x = p(1); y = p(2); f = p(3);
    refx = max(1,x-w); refy = max(1,y-w); finx = min(H,x+w+px-1); finy = min(W,y+w+py-1);
    hnew = finx-refx+1; wnew = finy-refy+1; loc = zeros(3,n*K); A = zeros(3*px*py,n*K);
    for iter = 1:K
        diffs = 255*(px*py+1)*ones(1,n); curLoc = zeros(3,n); curPat = zeros(3*px*py,n);
        for i = refx:refx+hnew-px
            for j = refy:refy+wnew-px
                curDiff = abs(meas(x:x+px-1,y:y+py-1,:,f)-meas(i:i+px-1,j:j+py-1,:,iter));
                curDiff = sum(sum(sum(curDiff)));
                [val,ind] = max(diffs);
                if curDiff < val
                    diffs(ind) = curDiff;
                    curLoc(:,ind) = [i;j;iter];
                    curPat(:,ind) = reshape(meas(i:i+px-1,j:j+py-1,:,iter),3*px*py,1);
                end
            end
        end
        loc(:,n*(iter-1)+1:n*iter) = curLoc;
        A(:,n*(iter-1)+1:n*iter) = curPat;
    end
end