% maa saraswati 
clear all; clc; close all;
% first code to do yearly trend analysis of all sky/clear sky and all sky
% w/o aerosol radiation spatial plot:

file='/home/sushovan/Documents/ceres_2001_2018_selected_var.nc';
lat_6_5=ncread(file,'lat');
lon_65_5=ncread(file,'lon');

diff_all=ncread(file,'adj_sfc_sw_diff_all_daily');
diff_clr=ncread(file,'adj_sfc_sw_diff_clr_daily');
diff_na=ncread(file,'adj_sfc_sw_diff_naer_daily');

direct_all=ncread(file,'adj_sfc_sw_direct_all_daily');
direct_clr=ncread(file,'adj_sfc_sw_direct_clr_daily');
direct_na=ncread(file,'adj_sfc_sw_direct_naer_daily');

% 
%%
for k = 1:18
     direct_all_year(:,:,k)= nanmean(direct_all(:,:,(((k-1)*365)+1):(k*365)),3);
     direct_clr_year(:,:,k)= nanmean(direct_clr(:,:,(((k-1)*365)+1):(k*365)),3);
     direct_naer_year(:,:,k)= nanmean(direct_na(:,:,(((k-1)*365)+1):(k*365)),3);
     diff_all_year(:,:,k)= nanmean(diff_all(:,:,(((k-1)*365)+1):(k*365)),3);
     diff_clr_year(:,:,k)= nanmean(diff_clr(:,:,(((k-1)*365)+1):(k*365)),3);
     diff_naer_year(:,:,k)= nanmean(diff_na(:,:,(((k-1)*365)+1):(k*365)),3);
end
clear diff_all diff_clr diff_na
clear direct_all direct_clr direct_na

%% trends
for k=1
    b1_direct_all_year=direct_all_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_direct_all_year=reshape(b1_direct_all_year(i,j,:),18,1);
            if (isnan(y_direct_all_year))
                tren1_direct_all_year(i,j)=NaN;
                pval1_direct_all_year(i,j)=NaN;
            else
                stats_direct_all_year=regstats(y_direct_all_year,x,'linear');
                tren1_direct_all_year(i,j)=stats_direct_all_year.tstat.beta(2,1);
                pval1_direct_all_year(i,j)=stats_direct_all_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_direct_all_year
end
clear k
size(tren1_direct_all_year)
size(pval1_direct_all_year)
%%
    for k=1
    b1_diff_all_year=diff_all_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_diff_all_year=reshape(b1_diff_all_year(i,j,:),18,1);
            if (isnan(y_diff_all_year))
                tren1_diff_all_year(i,j)=NaN;
                pval1_diff_all_year(i,j)=NaN;
            else
                stats_diff_all_year=regstats(y_diff_all_year,x,'linear');
                tren1_diff_all_year(i,j)=stats_diff_all_year.tstat.beta(2,1);
                pval1_diff_all_year(i,j)=stats_diff_all_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_diff_all_year
end
clear k
size(tren1_diff_all_year)
size(pval1_diff_all_year)
%%
 for k=1
    b1_direct_clr_year=direct_clr_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_direct_clr_year=reshape(b1_direct_clr_year(i,j,:),18,1);
            if (isnan(y_direct_clr_year))
                tren1_direct_clr_year(i,j)=NaN;
                pval1_direct_clr_year(i,j)=NaN;
            else
                stats_direct_clr_year=regstats(y_direct_clr_year,x,'linear');
                tren1_direct_clr_year(i,j)=stats_direct_clr_year.tstat.beta(2,1);
                pval1_direct_clr_year(i,j)=stats_direct_clr_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_direct_clr_year
end
clear k
size(tren1_direct_clr_year)
size(pval1_direct_clr_year)
%%
    for k=1
    b1_diff_clr_year=diff_clr_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_diff_clr_year=reshape(b1_diff_clr_year(i,j,:),18,1);
            if (isnan(y_diff_clr_year))
                tren1_diff_clr_year(i,j)=NaN;
                pval1_diff_clr_year(i,j)=NaN;
            else
                stats_diff_clr_year=regstats(y_diff_clr_year,x,'linear');
                tren1_diff_clr_year(i,j)=stats_diff_clr_year.tstat.beta(2,1);
                pval1_diff_clr_year(i,j)=stats_diff_clr_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_diff_clr_year
end
clear k
size(tren1_diff_clr_year)
size(pval1_diff_clr_year)
%%
for k=1
    b1_direct_naer_year=direct_naer_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_direct_naer_year=reshape(b1_direct_naer_year(i,j,:),18,1);
            if (isnan(y_direct_naer_year))
                tren1_direct_naer_year(i,j)=NaN;
                pval1_direct_naer_year(i,j)=NaN;
            else
                stats_direct_naer_year=regstats(y_direct_naer_year,x,'linear');
                tren1_direct_naer_year(i,j)=stats_direct_naer_year.tstat.beta(2,1);
                pval1_direct_naer_year(i,j)=stats_direct_naer_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_direct_naer_year
end
clear k
size(tren1_direct_naer_year)
size(pval1_direct_naer_year)
%%
    for k=1
    b1_diff_naer_year=diff_naer_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_diff_naer_year=reshape(b1_diff_naer_year(i,j,:),18,1);
            if (isnan(y_diff_naer_year))
                tren1_diff_naer_year(i,j)=NaN;
                pval1_diff_naer_year(i,j)=NaN;
            else
                stats_diff_naer_year=regstats(y_diff_naer_year,x,'linear');
                tren1_diff_naer_year(i,j)=stats_diff_naer_year.tstat.beta(2,1);
                pval1_diff_naer_year(i,j)=stats_diff_naer_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_diff_naer_year
end
clear k
size(tren1_diff_naer_year)
size(pval1_diff_naer_year)
%% all sky 
bottom=-1.0;
top=1.0;
figure
set(gcf,'color','white');
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_direct_all_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticallySignificant = pval1_direct_all_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('Direct(All-sky)','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticallySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
box on
colorbar;cbarrow
clear Lon1 Lat1 StatisticallySignificant hhh
%%
bottom=-1.0;
top=1.0;
figure
set(gcf,'color','white');
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_diff_all_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticallySignificant = pval1_diff_all_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('Diffuse (All Sky)','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticallySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
box on
colorbar;cbarrow
%% clear sky 
bottom=-1.0;
top=1.0;
figure
set(gcf,'color','white');
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_direct_clr_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticclrySignificant = pval1_direct_clr_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('Direct(Clear-sky)','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticclrySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
box on
colorbar;cbarrow
clear Lon1 Lat1 StatisticclrySignificant hhh
%%
bottom=-1.0;
top=1.0;
figure
set(gcf,'color','white');
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_diff_clr_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticclrySignificant = pval1_diff_clr_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('Diffuse (Clear Sky)','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticclrySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
box on
colorbar;cbarrow
clear Lon1 Lat1 StatisticclrySignificant hhh
%% no aerosol sky
bottom=-1.0;
top=1.0;
figure
set(gcf,'color','white');
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_direct_naer_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticnaerySignificant = pval1_direct_naer_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('Direct(No aerosol-sky)','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticnaerySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
box on
colorbar;cbarrow
clear Lon1 Lat1 StatisticnaerySignificant hhh
%%
bottom=-1.0;
top=1.0;
figure
set(gcf,'color','white');
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_diff_naer_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticnaerySignificant = pval1_diff_naer_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('Diffuse (No aerosol Sky)','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticnaerySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
box on
colorbar;cbarrow
clear Lon1 Lat1 StatisticnaerySignificant hhh
