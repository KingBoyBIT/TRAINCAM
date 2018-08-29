%% main
clear,clc,close all;
global data grid stat cluster
Eps = 80;
density = 1000000;
img = imread('��������ѧУ�պڰ�.jpg');
img = imresize(img,1);
img = rgb2gray(img);
% img = im2double(img);
data = [];
for i = 1:size(img,1)
	for j = 1:size(img,2)
		if img(i,j)<=100
			data=[data;i,j];
		end
	end
end
% set(0,'RecursionLimit',5000);
%�������ݣ�������Բ��Ϊ������Ҫ���ݺ��������
% data = SampleGenerator(density);
%view([90 90]);

%���񻯣�������ȡ��
% grid = GridSpace(data, 100); %�ֳ�100��
grid = floor(data)+1;

%ͳ�ƣ���ÿ��λ�ô���ĸ���
stat = zeros(max(grid(:, 1)), max(grid(:, 2)));
for i=1: size(data, 1)
	stat(grid(i, 1), grid(i, 2)) = stat(grid(i, 1), grid(i, 2)) + 1;
end
%��ʼ�������ֵ
cluster = zeros(size(stat));
cluster_num = 0;

%ɾȥ������
noise_threshold = 0; %�����ص����ֵ
cluster_num = cluster_num + 1; %�����հ״��ķ���Ϊ1
% AddIntoCluster(cluster_num, stat<=noise_threshold);
cluster(stat<=noise_threshold) = cluster_num;
stat(stat<=noise_threshold) = -1;% �������λ�ñ��Ϊ-1

%����
while true
	[PT, T_index] = max(stat(:));
	if PT == -1
		break;
	end
	cluster_num = cluster_num + 1;
	cluster(T_index) = cluster_num;
	stat(T_index) = -1;
	gather(cluster_num, PT, Eps, T_index);
end

figure(2);
% imagesc(rot90(-cluster));
imagesc((-cluster));
colorbar
colormap colorcube
title('������ͼ')

% figure(3);
% colorb = random('unif', 0, 1, [cluster_num, 3]);
% cc = colorb(cluster(grid(:, 1), grid(:, 2)), :);
% clear cluster grid stat
% plot(data(:, 1), data(:, 2), '.', 'Color', cc);

%% gather

function gather(cluster_num, PT, Eps, T_index)
global cluster stat
[Ti, Tj] = ind2sub(size(stat), T_index);

if Ti-1 >= 1 && Tj-1 >= 1   %����
	PR = stat(Ti-1, Tj-1);
	R_index = sub2ind(size(stat), Ti-1, Tj-1);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end

if Ti-1 >= 1   %��
	PR = stat(Ti-1, Tj);
	R_index = sub2ind(size(stat), Ti-1, Tj);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end

if Ti-1 >= 1 && Tj+1<=size(stat, 2)   %����
	PR = stat(Ti-1, Tj+1);
	R_index = sub2ind(size(stat), Ti-1, Tj+1);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end

if Tj-1 >= 1   %��
	PR = stat(Ti, Tj-1);
	R_index = sub2ind(size(stat), Ti, Tj-1);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end

if Tj+1 <= size(stat, 2)  %��
	PR = stat(Ti, Tj+1);
	R_index = sub2ind(size(stat), Ti, Tj+1);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end

if Ti+1 <= size(stat, 1) && Tj-1 >= 1   %����
	PR = stat(Ti+1, Tj-1);
	R_index = sub2ind(size(stat), Ti+1, Tj-1);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end

if Ti+1 <= size(stat, 1)   %��
	PR = stat(Ti+1, Tj);
	R_index = sub2ind(size(stat), Ti+1, Tj);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end

if Ti+1 <= size(stat, 1) && Tj+1 <= size(stat, 2)  %����
	PR = stat(Ti+1, Tj+1);
	R_index = sub2ind(size(stat), Ti+1, Tj+1);
	if PR>=0
		cluster(R_index) = cluster_num;
		stat(R_index) = -1;
		if PR>=PT-Eps
			gather(cluster_num, PT, Eps, R_index);
		end
	end
end
end

%% SampleGenerator
function data=SampleGenerator(density)
%��������������
data = zeros(100000, 2);
data(1:100, :) = random('unif', 0, 100, [100, 2]); %����
num = 100;

for i=1: 10
	origin = random('unif', 0, 100, [2, 1]);
	radius = random('unif', 0, 20);
	% ndata = CircleGenerator(density, origin, radius);
	%����Բ������
	raw_data = random('unif', 0, 100, [density, 2]);
	
	ndata = zeros(density, 2);
	numc=0;
	for j=1: density
		if ((raw_data(j, 1)-origin(1))^2 + (raw_data(j, 2)-origin(2))^2) <= radius^2
			numc = numc + 1;
			ndata(numc, :) = raw_data(j, :);
		end
	end
	ndata = ndata(1:numc, :);
	
	data(num+1: num+size(ndata, 1), :) = ndata;
	num = num + size(ndata, 1);
end
end
