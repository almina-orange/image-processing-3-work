clear all;
% % close all;
% clc;  clf;
warning('off', 'all');

%--------------------------------------------------------------------
% Resize images

%% load images
dirName = 'data/rectified';
extName = '*.png';
imgList = dir(fullfile(dirName, extName));
N = length(imgList);

%% output image path
outDirName = fullfile(dirName, 'resized');

msg = ['Resized Image path: ', outDirName];  disp(msg);
if ~exist(outDirName, 'dir')
    flag = input('[*] Directory is not found. Do you want to make directory? : ');
    if flag > 0
        mkdir(outDirName);
    end
end
mkdir(outDirName);

%% resized and save
scale = .5;
for ii=1:N
    msg = ['Image : ', imgList(ii).name];  disp(msg);

    img = imread(fullfile(dirName, imgList(ii).name));
    img = imresize(img, scale);
    imwrite(img, fullfile(outDirName, imgList(ii).name));
end


%--------------------------------------------------------------------
% Reforcus using Light Field (grayscale)

%% load images and parameters
dirName = 'data/rectified/resized';
extName = '*.png';
imgList = dir(fullfile(dirName, extName));
N = length(imgList);
[row,col,~] = size(imread(fullfile(dirName, imgList(1).name)));

img = zeros(row,col,N);
cen = [];
for ii=1:N
    img(:,:,ii) = rgb2gray(imread(fullfile(dirName, imgList(ii).name)));
    params = strsplit(imgList(ii).name, '_');
    tx = str2num(params{end-1});  ty = str2num(params{end-2});
    cen = [cen; [tx, ty]];
end


%% synthesis aperture image
accum = zeros(row,col,3);
for ii=1:N
    accum = accum + img(:,:,ii);
end
figure(1);  imshow(uint8(accum/N));  title('Synthesis aperture');


%% reforcus and image reconstruction
srcIdx = (N + 1) / 2;
sx = cen(srcIdx,1);  sy = cen(srcIdx,2);
f = 1.0;
for d=[0.2, 0.0, -0.2]
    accum = 0;
    scale = d / f;
    for ii=1:N
        tmp = imresize(img(:,:,ii), (1 - scale));
        tmp = imtranslate(tmp, [sx - cen(ii,1), sy - cen(ii,2)] * scale);
        accum = accum + tmp;
    end
    figure(2);  imshow(uint8(accum/N));  title(['Reforcus scale: ', num2str(scale)]);
    drawnow;
end


%--------------------------------------------------------------------
% Reforcus using Light Field (my function)

recImg = LF_reforcus('data/rectified', 0.2);
imshow(recImg);


%--------------------------------------------------------------------
% Change lens aperture

%% load images and parameters
dirName = 'data/rectified/resized';
extName = '*.png';
imgList = dir(fullfile(dirName, extName));
N = length(imgList);
[row,col,~] = size(imread(fullfile(dirName, imgList(1).name)));

img = zeros(row,col,N);
cen = [];
for ii=1:N
    img(:,:,ii) = rgb2gray(imread(fullfile(dirName, imgList(ii).name)));
    params = strsplit(imgList(ii).name, '_');
    tx = str2num(params{end-1});  ty = str2num(params{end-2});
    cen = [cen; [tx, ty]];
end


%% change lens aperture
srcIdx = (N + 1) / 2;
sx = cen(srcIdx,1);  sy = cen(srcIdx,2);
camArr = 17;
c = (camArr + 1) / 2;

for scale=.1:.1:1
    idx = reshape(1:N, camArr, camArr);
    r = round((camArr - 1) / 2 * scale);
    idx = idx(c-r:c+r,c-r:c+r);
    idx = reshape(idx, 1, size(idx,1) * size(idx,2));

    accum = zeros(row,col,3);
    for ii=idx
        accum = accum + img(:,:,ii);
    end
    imshow(uint8(accum/length(idx)));  title(['scale: ', num2str(scale)]);
    drawnow;
end
