%  	Compute 6-Connected Laplacian for confidence estimation problem
%   �����ӣ� �������ӶԽ��߷��� Ӧ���ǰ�����
%   Input:
%       P: �����Ȩͼ�������, �߽羭��padding 0
%       A: �����Ȩͼ��, �߽羭��padding 0
%       beta:   Random walks parameter
%       gamma:  Horizontal penalty factor
%   Output:
%       map:    Confidence map for data
function L = confidenceLaplacian( P, A, beta, gamma )
[m, n] = size(P);
p = find(P);    % ����0������
i = P(p);       % ��������, ��padding����
j = P(p);       % Index vector
s = zeros(size(p)); % Entries vector, initially for diagonal��ͼ���Сһ��
% Vertical edges
for k = [-1 1]
   Q = P(p + k);    % ���·�����   
   q = find(Q);     % ȥ���߽�
   ii = P( p(q) );  
   i = [i; ii];
   jj = Q(q);
   j = [j; jj];
   W = abs(A(p(ii)) - A(p(jj)));     % Intensity derived weight�������ȵ�Ȩ��
   s = [s; W];
end

vl = numel(s);                      % Ԫ�ظ���
% Diagonal edges    �Խ��ߺ����ұ߽�
for k = [(m-1) (m+1) (-m-1) (-m+1)]   
   Q = P(p+k);
   q = find(Q);    
   ii = P(p(q));
   i = [i; ii]; 
   jj = Q(q);
   j = [j; jj];
   W = abs(A(p(ii)) - A(p(jj))); % Intensity derived weight
   s = [s; W];
   
end


% Horizontal edges
for k = [m -m]
   Q = P(p+k);  
   q = find(Q);   
   ii = P(p(q));
   i = [i; ii];
   jj = Q(q);
   j = [j; jj];
   W = abs(A(p(ii))-A(p(jj))); % Intensity derived weight
   s = [s; W];
end
% sΪ���Ȳ�ֵ����
% Normalize weights
s = (s - min(s(:))) ./ (max(s(:)) - min(s(:)) + eps);

% Horizontal penalty
s(vl+1:end) = s(vl+1:end) + gamma;

% Normalize differences
s = (s - min(s(:))) ./ (max(s(:)) - min(s(:)) + eps);

% Gaussian weighting function
EPSILON = 10e-6;
s = -((exp(-beta * s)) + EPSILON);
% Create Laplacian, diagonal missing
L = sparse(i, j, s); % i,j indices, s entry (non-zero) vector ����ϡ�����L

% Reset diagonal weights to zero for summing 
% up the weighted edge degree in the next step, ��Ϊ�Խ�Ԫ�أ�Ϊ��㱾����ֵΪ�߽�Ȩ��֮��
L = spdiags(zeros(size(s, 1), 1), 0, L);        % replaces the diagonals specified by 0 with the columns of zeros(size(s, 1). The output is sparse.
% Weighted edge degree
D = full(abs(sum(L, 1)))';                      % ���ֵ

% Finalize Laplacian by completing the diagonal
L = spdiags(D,0,L);                             % ��D���ƻضԽ���
end

