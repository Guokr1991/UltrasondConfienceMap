function [img] = preproc_img(path)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
img = imread(path);
img = im2double(img);
img = imadjust(img, [0.007, 0.81]);

end

