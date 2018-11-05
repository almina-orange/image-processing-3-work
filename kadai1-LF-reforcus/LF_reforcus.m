function [recImg] = LF_reforcus(dirName, d)

% Reforcus using Light Field images.
%
% Input:
%   dirName - image directory path
%   d       - reforcus scale (0 to 1)
%
% Output:
%   recImg  - reforcused image

%% load images
extName = '*.png';
imgList = dir(fullfile(dirName, extName));
N = length(imgList);
[row,col,~] = size(imread(fullfile(dirName, imgList(1).name)));

%% reforcus and image reconstruction
f = 1.0;
scale = d / f;

srcIdx = (N + 1) / 2;  % source image index
params = strsplit(imgList(srcIdx).name, '_');
sx = str2num(params{end-1});  sy = str2num(params{end-2});

accum = 0;
for ii=1:N
    img = double(imread(fullfile(dirName, imgList(ii).name)));
    img = imresize(img, (1 - scale));  % resize image in scale

    params = strsplit(imgList(ii).name, '_');
    tx = str2num(params{end-1});  ty = str2num(params{end-2});
    tmp = imtranslate(img, [sx - tx, sy - ty] * scale);  % shift in scale to fit center position

    accum = accum + tmp;  % accumulation
end

recImg = uint8(accum/N);

end