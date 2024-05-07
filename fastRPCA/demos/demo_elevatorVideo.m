
%% Demo of RPCA on a video clip
% We demonstrate this on a video clip taken from a surveillance
% camera in a subway station.  Not only is there a background
% and a foreground (i.e. people), but there is an escalator
% with periodic motion.  Conventional background subtraction
% algorithms would have difficulty with the escalator, but 
% this RPCA formulation easily captures it as part of the low-rank
%   structure.
% The clip is taken from the data at this website (after
% a bit of processing to convert it to grayscale):
% http://perception.i2r.a-star.edu.sg/bk_model/bk_index.html

% Load the data:
%downloadEscalatorData;
dset=dir('dataset\0*');
 % contains X (data), m and n (height and width)
addpath 'C:\Users\Sin_Comp\Desktop\myproject\alltogeter\lowrank aligning\rpca\fastRPCA\fastRPCA-master\solvers'
addpath 'C:\Users\Sin_Comp\Desktop\myproject\alltogeter\lowrank aligning\rpca\fastRPCA\fastRPCA-master\utilities'
% X = double(X);
% nn=X(:,50);
% nn=reshape(nn,130,160);
% imwrite(nn,'1.png');
% imshow(mat2gray(nn));
for i=1:length(dset)
load(strcat('dataset','\',dset(i).name,'\','data')) 
mkdir(strcat('dataset','\',dset(i).name,'\',dset(i).name,'result'));
%% Run the algorithm
%{
We solve
    min_{L,S}  max( ||L||_* , lambda ||S||_1 )
    subject to
            || L+S-X ||_F <= epsilon
%}
nFrames     = size(X,2);
lambda      = 2e-2;
L0          = repmat( median(X,2), 1, nFrames );
S0          = X - L0;
epsilon     = 5e-3*norm(X,'fro'); % tolerance for fidelity to data
opts        = struct('sum',false,'L0',L0,'S0',S0,'max',true,...
    'tau0',3e5,'SPGL1_tol',1e-1,'tol',1e-3);
[L,S] = solver_RPCA_SPGL1(X,lambda,epsilon,[],opts);

%% show all together in movie format
% If you run this in your own computer, you can see the movie. On the webpage,
%   we have a youtube version of the video.
% The top row is using equality constraints, and the bottom row
% is using inequality constraints.
%  The first column of both rows is the same (i.e. it is the original image).
mat  = @(x) reshape( x, m, n );
figure(1); clf;
colormap( 'Gray' );
mIm=zeros(m,n);
for k = 1:nFrames
        
   imwrite(mat2gray(mat(L(:,k))),strcat('dataset','\',dset(i).name,'\',dset(i).name,'result','\',num2str(k),'.jpg'));
   mIm=+mat(L(:,k));
end
%imwrite(mat2gray(mIm/nFrames),strcat('dataset','\',dset(i).name,'\',dset(i).name,'result','\','mean.jpg'));
imwrite(mat2gray(mIm/nFrames),strcat('fastrpca_prima','\',dset(i).name,'.jpg'));
end