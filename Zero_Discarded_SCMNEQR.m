clc
%close all;
clear all;
Im = imread('Scenery_gray.jpg');
[row col]=size(Im);
Img2=Im(1:row,1:col);
%Img2= im2gray(Im1);
%Img2=im2double(Img2);
%Img2=round(Img2.*255);
Img2=Img2;
[row1 col1]=size(Img2);
blocksize=8;

PSNR1=0;
absB1q=0;

BR=0;
Z=zeros(row1, col1);
Y=zeros(row1, col1);
for i=1:blocksize:row1
  for j=1:blocksize:col1

W1=Img2(i:i+blocksize-1,j:j+blocksize-1);

[row col]=size(W1);

DCT=dct2(W1);

q=8;

B1q=round(DCT/q);


absB1q= abs(B1q);

%Max=max(max(absB1q));
%MN=min(min(absB1q));
%Bit rate calculation after DCT


[x y z]=find(absB1q);
dectoBin=dec2bin(z,8);

dectoBina=uint16(dectoBin);
dectoBina=dectoBina-48;
numone=nnz(dectoBina);

rowb=dec2bin(x,log2(blocksize));
urowb=uint16(rowb);
aurowb=urowb-48;
erowb=nnz(aurowb);

erowball=numel(aurowb);

colb=dec2bin(y,log2(blocksize));
ucolb=uint16(colb);
aucolb=ucolb-48;
ecolb=nnz(aucolb);

ecolball=numel(aucolb);

statebit=erowb+ecolb;

statebitall=erowball+ecolball;

statebitz=statebitall-statebit;

sbit=nnz(z);

auxbit=numone;

%tofolli=(statebit+1+1)*sbit;

tofolli=((log2(blocksize)+log2(blocksize)+1+1)*sbit);

tofolli=tofolli-statebitz;


BR=BR+(numone+sbit+statebit+auxbit+2*sbit)/(1024*1024);


%BR=BR+(numone+sbit+tofolli+auxbit)/(1024*1024);

B2=B1q.*q;

RI1=idct2(B2);

%figure 
%I1=imshow(RI1,[0, 255]);

Z(i:i+7,j:j+7)=RI1;
Y(i:i+7,j:j+7)=absB1q;

  end
end


%writematrix(absB1q, '70dearafterdct.csv');
PSNR1=CalculatePSNR(Img2, Z);

%tofolli=((log2(16)+log2(16)+1+1)*sbit)/(1000*1000);


numofblockr=row1/blocksize;
numofblockc=col1/blocksize;

rposioflastblock=row1-blocksize;
cposioflastblock=col1-blocksize;

numofcolbit=numel(dec2bin(rposioflastblock))-numel(dec2bin(blocksize));
numofrowbit=numel(dec2bin(cposioflastblock))-numel(dec2bin(blocksize));
tbitr=numofblockr*numofblockc*(numofcolbit+numofrowbit)/(1024*1024);

BR=BR+tbitr

bpp=(BR*1024*1024)/(row1*col1)
%BR*1000*1000
PSNR1