%for i = 1:100
%rng(0,'twister');    
cf=randi([25 150],100,1)*10;
bw = randi([5 50],100,1)*10;
d=cf.*2;
tsamp = 2.^(randi([5,10],100,1));
chans = 2.^(randi([9,12],100,1));
for i = 1:100
    while bw(i)*2.5 >= cf(i)
        bw(i)=floor(bw(i)/2);
    end
end
T = table(cf,bw,d,tsamp,chans);
writetable(T,'input_data.txt');
%end
