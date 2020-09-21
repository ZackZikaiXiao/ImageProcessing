clc;clear;
%% 参数输入区
filterSize = 5;
filterMode = 'median';
I=imread('./circuit.jpg');
%% 开始运行
I = rgb2gray(I);
% filterMode = 'average';
%%边界，数据格式（图像uint8，默认类型转换）

switch filterMode
    case 'average'
        [h,w] = size(I);
        imageOut = zeros(h, w);%为了扩充图像而创建的临时图像
        stepRange = (filterSize-1)/2;
        %%外层两个for循环用来定位窗口中心，内层两个for用来窗口滤波计算
        for pointRow = 1+stepRange : h-stepRange
            for pointCol = 1+stepRange : w-stepRange
                pixelSum = 0;
                for i = pointRow-stepRange:pointRow+stepRange
                    for j = pointCol-stepRange:pointCol+stepRange
                        pixelSum = pixelSum + double(I(i, j));
                    end
                end
                pixelValue = pixelSum/filterSize^2;
                imageOut(pointRow, pointCol) = uint8(pixelValue);
            end
        end
        imageOut = uint8(imageOut); %double转化为uint8格式
        imageOut = imcrop(imageOut,[1+stepRange,1+stepRange,w-2*stepRange-1,h-2*stepRange-1]);
        imageOut = imresize(imageOut, [h, w], 'bilinear');
        
    case 'median'
        [h,w] = size(I);
        imageOut = zeros(h, w);%为了扩充图像而创建的临时图像
        stepRange = (filterSize-1)/2;
        %%外层两个for循环用来定位窗口中心，内层两个for用来窗口滤波计算
        for pointRow = 1+stepRange : h-stepRange
            for pointCol = 1+stepRange : w-stepRange
                pixelArray = zeros(1, filterSize^2);
                ptrPA = 1;
                for i = pointRow-stepRange:pointRow+stepRange
                    for j = pointCol-stepRange:pointCol+stepRange
                        pixelArray(ptrPA) = double(I(i, j));
                        ptrPA = ptrPA + 1;
                    end
                end
                imageOut(pointRow, pointCol) = uint8(median(pixelArray));
            end
        end
        imageOut = uint8(imageOut); %double转化为uint8格式
        imageOut = imcrop(imageOut,[1+stepRange,1+stepRange,w-2*stepRange-1,h-2*stepRange-1]);
        imageOut = imresize(imageOut, [h, w], 'bilinear');
end

subplot(121),imshow(I);
subplot(122),imshow(imageOut);
impixelinfo;