clc;
dset=dir('dataset\0*');

X=[];

for j=1 : length(dset)
     names= dir(strcat('dataset','\',dset(j).name,'\','*.jpg'));
     dset(j).name
    for i=1: length(names)  
        temp=imread(strcat('dataset','\',dset(j).name,'\',names(i).name));
        temp=rgb2gray(temp);
        temp=histeq(temp);
        imshow(temp)
        X(:,i)=reshape(temp,size(temp,1)*size(temp,2),1);
    end
    m=size(temp,1);
    n=size(temp,2);
    save( strcat('dataset','\',dset(j).name,'\','data.mat'), 'X', 'm', 'n')
    X=[];
end