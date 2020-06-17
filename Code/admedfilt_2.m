% Code for adaptive median filtering

function res = admedfilt_2(im)
    H = size(im,1); W = size(im,2); res = im;
    for lambda = 1:3
        for x = 1:H
            for y = 1:W
                curpix = im(x,y,lambda);
                w = 1;
                refx = max(1,x-w); refy = max(1,y-w); finx = min(H,x+w); finy = min(W,y+w);
                arr = im(refx:finx,refy:finy,lambda); arr = arr(:); med = median(arr); M = max(arr); m = min(arr);
                while (~(med<M && med>m) && w<6)
                    w = w + 1;
                    refx = max(1,x-w); refy = max(1,y-w); finx = min(H,x+w); finy = min(W,y+w);
                    arr = im(refx:finx,refy:finy,lambda); arr = arr(:); med = median(arr);
                end
                if ~(curpix<M) || ~(curpix>m)
                    %if (med<M && med>m)
                        curpix = med;
                    %end
                end
                res(x,y,lambda) = med;
            end
        end
    end
end