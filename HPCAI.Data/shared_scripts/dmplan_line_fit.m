function [gradient,intersect] = dmplan_line_fit(dmplan)
xs = [dmplan(2,:),dmplan(5,end)*dmplan(4,end)];
ys = [0,dmplan(1,:)];
vector = polyfit(xs,ys,1);
gradient = vector(1);
intersect = vector(2);

end