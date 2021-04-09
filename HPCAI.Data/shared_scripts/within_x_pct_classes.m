function classes = within_x_pct_classes(table,x)
array = table2array(table);
classes = repmat("true", (height(table)/275), 1);

for t = 1:height(table)/275
    locys = (t-1)*275 + 1 : t*275;
    tempvec = array(locys,end);
    [~,indexes]= sort(tempvec);
    
    
    
    for i = 1:x
        if indexes(i) == 271
            classes(t) = "false";
            break;
        end
    end
end
return
end
    
