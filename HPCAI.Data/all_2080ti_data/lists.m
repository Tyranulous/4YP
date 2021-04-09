
list = randi(100, 100,1);
quick = quickSort(list);
quickc = issorted(quick)

%merge = merge(list);


function sortedList = quickSort(list)

pivot = length(list);
if pivot == 1
    sortedList = list;
    return
elseif pivot == 2
   if list(2) < list(1)
       sortedList = [list(2);list(1)];
       return
   else
       sortedList = list;
       return
   end
end
lowerList = 0;
llsize = 1;
upperList(1) = list(pivot);
ulsize = 2;
for i = 1:pivot-1
    if list(i) < list(pivot)
        lowerList(llsize,1) = list(i);
        llsize = llsize+1;
        
    else
        upperList(ulsize,1) = list(i);
        ulsize = ulsize + 1;
    end
end
if lowerList == 0;
    sortedList = quickSort(upperList);
else
sortedList = [quickSort(lowerList); quickSort(upperList)];
end


end