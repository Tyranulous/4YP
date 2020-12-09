function [xv,yv,xd,yd] = validation_sampler(xd,yd,n)


idx=randsample(1:size(xd,1),n);
xv = xd(idx,:);
yv = yd(idx,:);
xd(idx,:) = [];
yd(idx,:) = [];
end