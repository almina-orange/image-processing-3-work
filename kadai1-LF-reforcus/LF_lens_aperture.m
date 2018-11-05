function [recImg] = LF_lens_aperture(dirName, scale)

% Change lens aperture using Light Field images.
%
% Input:
%   dirName - image directory path
%   scale   - scale of changing lens aperture (0 to 1)
%
% Output:
%   recImg  - reconstructed image

%% load images
extName = '*.png';
imgList = dir(fullfile(dirName, extName));
N = length(imgList);
[row,col,~] = size(imread(fullfile(dirName, imgList(1).name)));


%% change lens aperture
camArr = 17;  c = (camArr + 1) / 2;  % center of camera array
srcIdx = (N + 1) / 2;  % source image index
params = strsplit(imgList(srcIdx).name, '_');
sx = str2num(params{end-1});  sy = str2num(params{end-2});

idx = reshape(1:N, camArr, camArr);
r = round((camArr - 1) / 2 * scale);
idx = idx(c-r:c+r,c-r:c+r);  % clip using index
idx = reshape(idx, 1, size(idx,1) * size(idx,2));

accum = zeros(row,col,3);
for ii=idx
    img = double(imread(fullfile(dirName, imgList(ii).name)));
    accum = accum + img;
end

recImg = uint8(accum/length(idx));

end