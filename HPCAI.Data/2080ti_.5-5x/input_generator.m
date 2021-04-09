%for i = 1:300
%rng(0,'twister');
num_generated = 500;

cf=randi([30 200],num_generated,1)*10;
bw = randi([5 70],num_generated,1)*10;
d=cf.*2;
tsamp = 2.^(randi([5,10],num_generated,1));
chans = 2.^(randi([9,12],num_generated,1));
for i = 1:300
    while bw(i)*2 >= cf(i)
        bw(i)=floor(bw(i)/randi([1,2],1,1));
    end
end
T = table(cf,bw,d,tsamp,chans);
writetable(T,'input_data.txt');
%end
