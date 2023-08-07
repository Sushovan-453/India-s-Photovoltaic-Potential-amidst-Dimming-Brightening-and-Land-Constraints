clc;clear all; close all;
cd '/scratch/cas/phd/asz188660/solar_dim_bright/NDVI'

projectdir = '/scratch/cas/phd/asz188660/solar_dim_bright/NDVI';
dinfo = dir( fullfile(projectdir, '**', '*2015*') );
num_files = length(dinfo);
filenames = fullfile( {dinfo.folder}, {dinfo.name} );


for i=1:12
    ndvi{i,1}=ncread(filenames{1,i},'MOD13C2_006_CMG_0_05_Deg_Monthly_NDVI');
end

lat=ncread(filenames{1,1},'lat');
lon=ncread(filenames{1,1},'lon');
[x,y]=meshgrid(lat,lon);

c=cat(3,ndvi{:,1});
c(c==--3000)=NaN;
ndvi_ann_clim(:,:)=nanmean(c,3);
% figure; pcolor(lon,lat,ndvi_ann_clim'); colorbar
% figure;geoshow(x,y,ndvi_ann_clim,'DisplayType','Surface'); colorbar
%% 
ndvi_low=ndvi_ann_clim;
ndvi_low(ndvi_low>0.45)=NaN;
% figure;geoshow(x,y,ndvi_ann_clim,'DisplayType','Surface'); colorbar
% title('ORIGINAL')
% figure;geoshow(x,y,ndvi_low,'DisplayType','Surface'); colorbar

%%
w_nor=shaperead('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp');
for i=1:1
    X=w_nor(i).X; % longitude
    Y=w_nor(i).Y; % latitude
    X=X';
    Y=Y';
    in=inpolygon(reshape(x,700*700,1),reshape(y,700*700,1),Y,X);
    mask{i,1}=in;
    i
end

%%
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'

% save masked_India.mat 'mask'

%%
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load masked_India.mat 'mask'
a=cell2mat(mask(1,1));
a_rs=reshape(a,700,700);
b=ndvi_ann_clim;
b(a_rs==0)=NaN;
figure;geoshow(x,y,b,'DisplayType','Surface'); colorbar
bb=ndvi_low;
bb(a_rs==0)=NaN;
figure;geoshow(x,y,bb,'DisplayType','Surface'); colorbar
hold on; 
geoshow('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp', 'FaceColor', 'none','LineWidth',2);

