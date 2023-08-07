clc;clear all;close all;

cd /home/cas/phd/asz188660/scratch/solar_dim_bright/all_dot_mat_file
load masked_radiation_CERES_FINAL.mat

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load NDVI_GHSL_661_626.mat sara_lat sara_lon ndvi_2015 g_2015

% figure; geoshow(sara_lat, sara_lon, msk_ALL_FINAL_REGRID_CLIM,'DisplayType', 'Surface'); colorbar;
% figure; geoshow(sara_lat, sara_lon, msk_CLEAR_FINAL_REGRID_CLIM,'DisplayType', 'Surface'); colorbar;
% figure; geoshow(sara_lat, sara_lon, msk_NAER_FINAL_REGRID_CLIM,'DisplayType', 'Surface'); colorbar;

%% trend analysis:
msk_aerosol_impact=(msk_NAER_FINAL_REGRID_YRLY-msk_ALL_FINAL_REGRID_YRLY);
for k=1
    b1_total_all_year=msk_ALL_FINAL_REGRID_YRLY;
    for i=1:661 % longitude
        for j=1:626 % lattitude
            x=[1:16]'; %%%[number of years]
            y_total_all_year=reshape(b1_total_all_year(i,j,:),16,1);
            if (isnan(y_total_all_year))
                tren1_total_all_year(i,j)=NaN;
                pval1_total_all_year(i,j)=NaN;
            else
                stats_total_all_year=regstats(y_total_all_year,x,'linear');
                tren1_total_all_year(i,j)=stats_total_all_year.tstat.beta(2,1);
                pval1_total_all_year(i,j)=stats_total_all_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_total_all_year
end
clear k
size(tren1_total_all_year)
size(pval1_total_all_year)
%%
g_2015_high=g_2015;
g_2015_high(g_2015_high<1)=NaN;
g_2015_high(g_2015_high>3)=NaN;

g_2015_zero=g_2015;
g_2015_zero(g_2015_zero>0)=NaN;
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

%%
rad_trd_all_no_set_pos_ndvi=tren1_total_all_year;
rad_trd_all_no_set_pos_ndvi(isnan(g_combined))=NaN;

rad_pval_all_no_set_pos_ndvi=pval1_total_all_year;
rad_pval_all_no_set_pos_ndvi(isnan(g_combined))=NaN;

FigH5=figure;
set(gcf,'color','white');
bottom=-0.5;
top=0.5;
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
colormap(brewermap([],'*RdBu'))
h=pcolor(lon_sara,lat_sara,rad_trd_all_no_set_pos_ndvi');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
shading interp;
hold on;
geoshow('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',1);
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/world_map_10_01_17.shp','Color','k','linewidth',0.5);
title('all_sky','fontsize',12,'fontweight','bold');
StatisticallySignificant = rad_pval_all_no_set_pos_ndvi<= 0.05;
[Lon1,Lat1] = meshgrid(lon_sara,lat_sara);
hold on
title('all-sky tr','fontsize',16,'fontweight','bold');
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
stipple(Lon1,Lat1,StatisticallySignificant','color','k','marker','.','markersize',6,'DensityValue',100)
axis([66 99 6 39])
set(gca,'XTick',65:5:100,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',5:5:40,'fontweight','bold')
ylabel('lat(^oN)','FontWeight','bold');
xlabel('lon(^oE)','FontWeight','bold');
colorbar;
cbarrow; 
clear Lon1 Lat1 StatisticallySignificant 
% cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm'
% saveas(FigH5, 'all_sky_MAM_trend.png','png');
hold on 
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp','FaceColor','none');
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load solar_park_loc.mat
lat_pt = Latitude;
lon_pt = Longitude;
hh=geoshow( lat_pt,lon_pt,'DisplayType', 'Point', 'Marker', '*','MarkerEdgeColor','g','MarkerSize',12);
set(hh,'LineWidth',2.0);
%%
s=shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp');

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load mask_state_wise.mat maskin

%%
d1=reshape(rad_trd_all_no_set_pos_ndvi,661*626,1);
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
India = shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp', 'usegeocoords', true);
rad_mean_state=cell2mat(rad_2015_mean);
for ii = 1:numel(India)
  India(ii).rad_mean_state_trend = rad_mean_state(ii); % add your data here
  
end
figure()
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
colormap(brewermap([12],'*RdBu'))

% colormap(turbo(24))
riskSymbolSpec = makesymbolspec('Polygon', ...
  {'rad_mean_state_trend',[-0.7 0.7],'FaceColor',colormap});
geoshow(India,'SymbolSpec',riskSymbolSpec)
title('Radiation tr:2001-18','FontSize',18,'FontWeight','Bold')
box on
c = colorbar;
w = c.LineWidth;
c.LineWidth = 2.0;
caxis([-0.6 0.6])
c.Label.String = 'W/m^2 per yr';
c.Label.FontSize=16;
c.Label.FontWeight='Bold';
hold on 
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp','FaceColor','none');
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load solar_park_loc.mat
lat_pt = Latitude;
lon_pt = Longitude;
hh=geoshow( lat_pt,lon_pt,'DisplayType', 'Point', 'Marker', '*','MarkerEdgeColor','g','MarkerSize',12);
set(hh,'LineWidth',2.0);