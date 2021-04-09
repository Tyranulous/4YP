function output = dmplan_variancer(dmplan)

output = var((dmplan(1,:).*dmplan(3,:)));

end