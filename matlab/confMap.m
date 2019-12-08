%  	Compute confidence map
%   Input:
%       data:   ������RF�ź����ݣ�ÿһ��Ϊһ��ɨ����[m, n]
%       mode:   'RF' or 'B' mode data��ģʽѡ��RF��B�ͳ�������
%       alpha, beta, gamma: See Medical Image Analysis reference����ͼ�����͵����Ĳ�����������    
%   Output:
%       map:    Confidence map for data, ��ά�ľ���ĸ���ͼ
function [ map ] = confMap( data, alpha, beta, gamma, mode)
% Ĭ�ϲ�������
if nargin < 4
    alpha = 2.0;
    beta = 90;
    gamma = 0.05;
end
% Ĭ��ͼ������
if(nargin < 5)
    mode = 'B';
end
% ͼ���һ��
data = double(data);
data = (data - min(data(:))) ./ ((max(data(:))-min(data(:)))+eps);
% ת����ϣ�����ؿռ�v
if(strcmp(mode, 'RF'))
    data = abs(hilbert(data));
end
% Seeds and labels (boundary conditions)
seeds = [];
labels = [];
sc = 1: size(data, 2);                   %All elements������
sr_up = ones(1, length(sc));            % ע������ȫ��Ϊ1
seed = sub2ind(size(data), sr_up, sc);  % ���±�ת��Ϊ�������е����꣬����ת�������������ȫ��Ϊ1���������е�һ��Ԫ�ص�����
seed = unique(seed);
seeds = [seeds seed];
% Label 1
label = zeros(1,length(seed));
label = label + 1;
labels = [labels label];                % ̽ͷԪ�����ñ�ǩΪ1
sr_down = ones(1,length(sc));
sr_down = sr_down * size(data,1);       % ȫ��Ϊ[n_rows....n_rows]
seed = sub2ind(size(data),sr_down,sc);  % �������һ�е�����
seed = unique(seed);
seeds = [seeds seed];
%Label 2
label = zeros(1,length(seed));
label = label + 2;
labels = [labels label];                % ���һ�б��Ϊ2
% Attenuation with Beer-Lambert
% W = attenuationWeighting(data, alpha);  % ˥��Ȩ�ؾ���
W = attenuationWeighting2(data);
% Apply weighting directly to image
% Same as applying it individually during the formation of the Laplacian
data = data .* W;                       % ͼ���Ȩ
% Find condidence values�������ֵ
map = confidenceEstimation( data, seeds, labels, beta, gamma);
% Only keep probabilities for virtual source notes.
map = map(:, :, 1);   % size is [n_rows, n_cols, 2]
end

