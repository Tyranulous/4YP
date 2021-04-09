function output = dmplanstepmean(dmplan,shape)
output = sum(dmplan(1,:).*dmplan(3,:))/shape(2);
end