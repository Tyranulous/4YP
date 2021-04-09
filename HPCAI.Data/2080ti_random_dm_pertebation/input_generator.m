%for i = 1:300
%rng(0,'twister');
num_telescopes = 1500;

cf=randi([25 200],num_telescopes,1)*10;
bw = randi([5 50],num_telescopes,1)*10;
d=cf.*2;
tsamp = 2.^(randi([5,10],num_telescopes,1));
chans = 2.^(randi([9,12],num_telescopes,1));
for i = 1:num_telescopes
    while bw(i)*2.5 >= cf(i)
        bw(i)=floor(bw(i)/2);%randi([1,2],1,1));
    end
end
T = table(cf,bw,d,tsamp,chans);
writetable(T,'input_data.txt');
clear num_telescopes cf bw d tsamp chans 
%end
