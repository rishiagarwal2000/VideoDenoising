% Code for adaptive median filtering

function res = admedfilt(im)
    H = size(im,1); W = size(im,2); res = im;
    for lambda = 1:3
        for x = 1:H
            for y = 1:W
                curpix = im(x,y,lambda);
                if curpix < 255 && curpix > 0
                    continue
                else
                    w = 1;
                    refx = max(1,x-w); refy = max(1,y-w); finx = min(H,x+w); finy = min(W,y+w);
                    arr = im(refx:finx,refy:finy,lambda); arr = arr(:); med = median(arr);
                    while (~(med<255 && med>0) && w<6)
                        w = w + 1;
                        refx = max(1,x-w); refy = max(1,y-w); finx = min(H,x+w); finy = min(W,y+w);
                        arr = im(refx:finx,refy:finy,lambda); arr = arr(:); med = median(arr);
                    end
                    res(x,y,lambda) = med;
                end
            end
        end
    end
end