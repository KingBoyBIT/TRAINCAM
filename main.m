clear,clc,close all
global data grid stat cluster

img = imread('img01.jpg');
thresh = graythresh(img);     %�Զ�ȷ����ֵ����ֵ
imgBW = im2bw(img,thresh);       %��ͼ���ֵ��

tempImage=imread('switch01.jpg');
thresh = graythresh(tempImage);     %�Զ�ȷ����ֵ����ֵ
tempImageBW = im2bw(tempImage,thresh);       %��ͼ���ֵ��
vec_sub = double( tempImageBW(:) );
norm_sub = norm( vec_sub );

% parpool(4);
[m,n]=size(imgBW);
[tm,tn] = size(tempImageBW);
result = zeros(m-tm+1,n-tn+1);
parfor i = 1:m-tm+1
	for j = 1:n-tn+1
		subMatr=imgBW(i:i+tm-1,j:j+tn-1);
        vec=double( subMatr(:) );
        result(i,j)=vec'*double(tempImageBW(:)) / (norm(vec)*norm_sub+eps);
	end
	if (mod(i,100)==0)
		fprintf('%d\n',i);
	end
end
%%
[tx,ty]=find( result>0.92);
data=[tx,ty];

epsilon= 0.15 ;
MinPts=  3   ;
IDX1=DBSCAN(data,epsilon,MinPts);


fprintf('�������\n')
%%
% imshow(result)
figure
imshow(img)
hold on
% plot(jMaxPos,iMaxPos,'*');%���������ص�
%�þ��ο��ǳ�ƥ������
for i = 1:length(tx)
	iMaxPos = tx(i);
	jMaxPos = ty(i);
	plot([jMaxPos,jMaxPos+tn-1],[iMaxPos,iMaxPos],'-r','linewidth',2);
	plot([jMaxPos+tn-1,jMaxPos+tn-1],[iMaxPos,iMaxPos+tm-1],'-r','linewidth',2);
	plot([jMaxPos,jMaxPos+tn-1],[iMaxPos+tm-1,iMaxPos+tm-1],'-r','linewidth',2);
	plot([jMaxPos,jMaxPos],[iMaxPos,iMaxPos+tm-1],'-r','linewidth',2);
end
% figure
% imshow(tempImageBW)
