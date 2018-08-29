function result = searchTemplate(tempImage,subimg)
% thresh = graythresh(subimg);
subimgBW = subimg;
% subimgBW = im2bw(subimg,thresh);
thresh = graythresh(tempImage);     %�Զ�ȷ����ֵ����ֵ
tempImageBW = im2bw(tempImage,thresh);       %��ͼ���ֵ��
tempImageBW = ~tempImageBW;
[m,n]=size(subimg);
[tm,tn] = size(tempImageBW);
result = zeros(m-tm+1,n-tn+1);
for i = 1:m-tm+1
	for j = 1:n-tn+1
		subMat=subimgBW(i:i+tm-1,j:j+tn-1);
		subMat = ~subMat;
		
        result(i,j) = sum(sum(subMat&tempImageBW))/sum(sum(tempImageBW));
	end
end
end