clc;clear all;close all;

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load NDVI_GHSL_661_626.mat sara_lat sara_lon ndvi_2015 g_2015

g_2015_high=g_2015;
g_2015_high(g_2015_high<1)=NaN;
g_2015_high(g_2015_high>3)=NaN;

g_2015_zero=g_2015;
g_2015_zero(g_2015_zero>0)=NaN;


figure; geoshow(sara_lat,sara_lon,g_2015,'DisplayType', 'Surface'); colorbar;
fig1=figure; 
geoshow(sara_lat,sara_lon,g_2015_high,'DisplayType', 'Surface'); colormap('summer'); colorbar;
hold on 
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp','FaceColor','none');
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load solar_park_loc.mat
lat_pt = Latitude;
lon_pt = Longitude;
geoshow( lat_pt,lon_pt,'DisplayType', 'Point', 'Marker', '*','MarkerSize',7, 'Color', 'black');

saveas(fig1,'rural_urban_hdu.png','png');

%% ndvi 7 no settlement grid criteria
ndvi_low=ndvi_2015;
ndvi_low(ndvi_low>0.4)=NaN;
ndvi_pos=ndvi_low;
ndvi_pos(ndvi_pos<0.07)=NaN;
figure; geoshow(sara_lat,sara_lon,ndvi_pos,'DisplayType', 'Surface'); colorbar;

g_2015_no_set_pos_ndvi=g_2015_zero;
g_2015_no_set_pos_ndvi(isnan(ndvi_pos))=NaN;
figure; geoshow(sara_lat,sara_lon,g_2015_no_set_pos_ndvi,'DisplayType', 'Surface'); colorbar;

%%
g_combined=NaN(661,626);
g_combined(~isnan(g_2015_no_set_pos_ndvi))=12;
g_combined(~isnan(g_2015_high))=13;
figure; 
pcolor(sara_lon,sara_lat,g_combined);
shading interp
colormap('summer'); 
colorbar;
hold on 
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp','FaceColor','none');
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load solar_park_loc.mat
lat_pt = Latitude;
lon_pt = Longitude;
geoshow( lat_pt,lon_pt,'DisplayType', 'Point', 'Marker', '*','MarkerSize',7, 'Color', 'black');

save suitable_grid_pts.mat sara_lon sara_lat g_combined

%%

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'

load masked_radiation_CERES_CLIM.mat msk_ALL_FINAL_REGRID_CLIM  msk_CLEAR_FINAL_REGRID_CLIM ...
     msk_NAER_FINAL_REGRID_CLIM  lat_sara lon_sara ...

aerosol_impac=msk_NAER_FINAL_REGRID_CLIM-msk_ALL_FINAL_REGRID_CLIM;
rad_all_no_set_pos_ndvi=aerosol_impac+msk_ALL_FINAL_REGRID_CLIM;
% rad_all_no_set_pos_ndvi=msk_ALL_FINAL_REGRID_CLIM;
rad_all_no_set_pos_ndvi(isnan(g_combined))=NaN;
% figure; geoshow(sara_lat, sara_lon, rad_all_no_set_pos_ndvi,'DisplayType', 'Surface'); 
figure;
pcolor(sara_lon,sara_lat,rad_all_no_set_pos_ndvi);
shading interp
colorbar;
colormap('turbo');
hold on 
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp','FaceColor','none');
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load solar_park_loc.mat
lat_pt = Latitude;
lon_pt = Longitude;
geoshow( lat_pt,lon_pt,'DisplayType', 'Point', 'Marker', 'o','MarkerEdgeColor','k','MarkerSize',12);

%% impolygon function 
s=shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp');

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load mask_state_wise.mat maskin

%%
d1=reshape(rad_all_no_set_pos_ndvi,661*626,1);
%%
newcell=maskin;
for i=1:36
    maskstate=newcell{i,1};
    [r,c]=find(maskstate==1);
    rad_2015_msk{i,1}=d1(r,1);
    rad_2015_msk{i,2}=r;
    clear r c maskstate 
    
end 

for i=1:36
    rad_2015_mean{i,1}=mean(rad_2015_msk{i,1},'omitNaN');
%     rad_2015_mean{i,2}=size(rad_2015_msk{i,1});
    i
    
end
for i=1:36
    aa=cell2mat(rad_2015_msk(i,1));
    dd=nnz(~isnan(aa));
    cc{i,1}=dd;
    clear aa dd 
    i
end
    
  %%
  %https://in.mathworks.com/matlabcentral/answers/420935-attach-a-field-to-a-shapefile-and-plot-it
India = shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp', 'usegeocoords', true);
rad_mean_state=cell2mat(rad_2015_mean);
for ii = 1:numel(India)
  India(ii).rad_mean_state_w_o_aer = rad_mean_state(ii); % add your data here
  
end

%% continous color scheme
% based on :https://in.mathworks.com/matlabcentral/answers/113924-filling-a-polygon-using-an-index-and-colormap
% pm2.5

figure()
% cd('/home/cas/phd/asz188660/scratch/asp_731_project')
% colormap(brewermap([7],'*Spectral'))

colormap(turbo(24))
riskSymbolSpec = makesymbolspec('Polygon', ...
  {'rad_mean_state',[150 260],'FaceColor',colormap});
geoshow(India,'SymbolSpec',riskSymbolSpec)
title('Radiation:2001-18','FontSize',18,'FontWeight','Bold')
box on
c = colorbar;
w = c.LineWidth;
c.LineWidth = 2.0;
caxis([150 270])
c.Label.String = 'W/m^2';
c.Label.FontSize=16;
c.Label.FontWeight='Bold';
%%
% % % % cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
% % % % load mask_state_wise.mat maskin
% % % % 
% % % % %%
% % % % d1_org=reshape(msk_ALL_FINAL_REGRID_CLIM,661*626,1);
% % % % %%
% % % % newcell_org=maskin;
% % % % for i=1:36
% % % %     maskstate_org=newcell_org{i,1};
% % % %     [r_org,c_org]=find(maskstate_org==1);
% % % %     rad_2015_msk_org{i,1}=d1_org(r_org,1);
% % % %     rad_2015_msk_org{i,2}=r_org;
% % % %     clear r_org c_org maskstate_org 
% % % %     
% % % % end 
% % % % 
% % % % for i=1:36
% % % %     rad_2015_mean_org{i,1}=mean(rad_2015_msk_org{i,1},'omitNaN');
% % % % %     rad_2015_mean{i,2}=size(rad_2015_msk{i,1});
% % % %     i
% % % %     
% % % % end
% % % % for i=1:36
% % % %     aa_org=cell2mat(rad_2015_msk_org(i,1));
% % % %     dd_org=nnz(~isnan(aa_org));
% % % %     cc_org{i,1}=dd_org;
% % % %     clear aa dd 
% % % %     i
% % % % end
% % % %     
% % % %   %%
% % % %   %https://in.mathworks.com/matlabcentral/answers/420935-attach-a-field-to-a-shapefile-and-plot-it
% % % % India = shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp', 'usegeocoords', true);
% % % % rad_mean_state_org=cell2mat(rad_2015_mean_org);
% % % % for ii = 1:numel(India)
% % % %   India(ii).rad_mean_state_org = rad_mean_state_org(ii); % add your data here
% % % %   
% % % % end
% % % % 
% % % % %% continous color scheme
% % % % % based on :https://in.mathworks.com/matlabcentral/answers/113924-filling-a-polygon-using-an-index-and-colormap
% % % % % pm2.5
% % % % figure()
% % % % colormap(jet(18))
% % % % riskSymbolSpec = makesymbolspec('Polygon', ...
% % % %   {'rad_mean_state_org',[150 240],'FaceColor',colormap});
% % % % geoshow(India,'SymbolSpec',riskSymbolSpec)
% % % % title('Radiation:2001-18','FontSize',18,'FontWeight','Bold')
% % % % hold on
% % % % 
% % % % cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
% % % % load solar_park_loc.mat
% % % % lat_pt = Latitude;
% % % % lon_pt = Longitude;
% % % % geoshow( lat_pt,lon_pt,'DisplayType', 'Point', 'Marker', '*','Color', 'black','MarkerSize',7);
% % % % 
% % % % box on
% % % % c_org = colorbar;
% % % % w = c_org.LineWidth;
% % % % c_org.LineWidth = 2.0;
% % % % caxis([150 240])
% % % % c_org.Label.String = 'w/m^2';
% % % % c_org.Label.FontSize=16;
% % % % c_org.Label.FontWeight='Bold';  
% % % %     
% % % %     
% % % %     
