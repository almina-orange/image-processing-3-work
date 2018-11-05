WIDTH = 700;
HEIGHT = 400;

pngFiles = dir('rectified/resize/*.png');
numfiles = length(pngFiles);
mydata = cell(1,numfiles);

a = zeros(HEIGHT,WIDTH,3);

for k=1:numfiles
    filename = ['rectified/resize/',pngFiles(k).name];
    a =double(a) + double(imread(filename));
end


b = a / numfiles;
%%
figure;
imshow(uint8(b));

%%
for d=.1:.05:.3

WIDTH = 700;
HEIGHT = 400;
tmp = zeros(HEIGHT,WIDTH,3);

ori_y = 818.578247;
ori_x = 3313.998047;

for k=1:numfiles
    filename = ['data/rectified/resize/',pngFiles(k).name];
    c = double(imread(filename));
    position = strsplit(filename,'-');
    x = strsplit(position{3},'_');
    y = strsplit(position{2},'_');
    
    sax = - str2double(x{1}) + ori_x;
    say = - str2double(y{1}) + ori_y;
    
    c = double(imread(filename));    
    %c = imresize(c,0.5);
    %c = imtranslate(c,[sax*0.2,say*0.2]);
    c = imtranslate(c,[sax*d,say*d]);
    %c = imresize(c,10/5);
    tmp = double(tmp) + c; 
    
end


tmp = tmp / numfiles;
figure(1)
imshow(uint8(tmp));
drawnow
end
%%
%{
tmp = zeros(HEIGHT,WIDTH,3);


for
    
    k=1:numfiles
    filename = ['rectified/resize/',pngFiles(k).name];
    
    c = double(imread(filename));    
    c = imresize(c,0.5);
    d = imresize(c,2);
    tmp = double(tmp) + d; 
    
end

tmp = tmp / numfiles;
figure
imshow(uint8(tmp));


%}

