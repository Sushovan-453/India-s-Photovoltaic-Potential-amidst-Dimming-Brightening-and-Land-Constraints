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

total_all=diff_all+direct_all;
total_clr=diff_clr+direct_clr;
total_na=diff_na+direct_na;
clear diff_all diff_clr diff_na
clear direct_all direct_clr direct_na
%%
for k = 1:18
     total_all_year(:,:,k)= nanmean(total_all(:,:,(((k-1)*365)+1):(k*365)),3);
     total_clr_year(:,:,k)= nanmean(total_clr(:,:,(((k-1)*365)+1):(k*365)),3);
     total_naer_year(:,:,k)= nanmean(total_na(:,:,(((k-1)*365)+1):(k*365)),3);
end

%% checking of my code
total_1st(:,:)=nanmean(total_all(:,:,366:730),3);
m=total_all_year(:,:,2);
y=isequal(total_1st,m)
clear total_all total_clr total_na
% it is correct!!
%% trend analysis yearly basis:
%% trend analysis
% CESM2 Model 
for k=1
    b1_total_all_year=total_all_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_total_all_year=reshape(b1_total_all_year(i,j,:),18,1);
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
bottom=-0.7;
top= 0.7;
figure
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_total_all_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticallySignificant = pval1_total_all_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('All Sky Radiation','fontsize',16,'fontweight','bold');
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
%% clear sky trends
for k=1
    b1_total_clr_year=total_clr_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_total_clr_year=reshape(b1_total_clr_year(i,j,:),18,1);
            if (isnan(y_total_clr_year))
                tren1_total_clr_year(i,j)=NaN;
                pval1_total_clr_year(i,j)=NaN;
            else
                stats_total_clr_year=regstats(y_total_clr_year,x,'linear');
                tren1_total_clr_year(i,j)=stats_total_clr_year.tstat.beta(2,1);
                pval1_total_clr_year(i,j)=stats_total_clr_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_total_clr_year
end
clear k
size(tren1_total_clr_year)
size(pval1_total_clr_year)
%%
bottom=-0.7;
top= 0.7;
figure
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_total_clr_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticclrySignificant = pval1_total_clr_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('Clear Sky Radiation','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticclrySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
colorbar;cbarrow
clear Lon1 Lat1 StatisticclrySignificant hhh
box on
%% no aerosol trends
for k=1
    b1_total_naer_year=total_naer_year;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_total_naer_year=reshape(b1_total_naer_year(i,j,:),18,1);
            if (isnan(y_total_naer_year))
                tren1_total_naer_year(i,j)=NaN;
                pval1_total_naer_year(i,j)=NaN;
            else
                stats_total_naer_year=regstats(y_total_naer_year,x,'linear');
                tren1_total_naer_year(i,j)=stats_total_naer_year.tstat.beta(2,1);
                pval1_total_naer_year(i,j)=stats_total_naer_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_total_naer_year
end
clear k
size(tren1_total_naer_year)
size(pval1_total_naer_year)
%%
bottom=-0.7;
top= 0.7;
figure
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,tren1_total_naer_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
StatisticnaerySignificant = pval1_total_naer_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_65_5,lat_6_5);
hold on
title('No aerosol Sky Radiation','fontsize',16,'fontweight','bold');
addpath('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6');
stipple(Lon1,Lat1,StatisticnaerySignificant','color','k','marker','.','markersize',6)
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
colorbar;cbarrow
clear Lon1 Lat1 StatisticnaerySignificant hhh
box on
%% contribution of how much all sky trends are matching with the clear sky and no aerosol sky flux:
all_div_clr=tren1_total_all_year./tren1_total_clr_year;
all_div_naer=tren1_total_all_year./tren1_total_naer_year;

%%
% https://in.mathworks.com/matlabcentral/answers/203697-logarithmic-scale-for-colorbar
bottom=-2.5;
top= 2.5;
figure
addpath ('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6')
colormap(brewermap([],'*RdBu'))
%colormap(brewermap([],'BuPu'))
h=pcolor(lon_65_5,lat_6_5,all_div_naer');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
% C=caxis(log([bottom top]));
% set(gca,'colorscale','log')
% shading interp;
hold on;
geoshow('/home/sushovan/Downloads/CMIP6-HISTO-AOD-550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',2.5);
geoshow('/home/sushovan/Documents/world_map_10_01_17.shp','Color','k','linewidth',1);
hold on
title('(All/Clear)trend','fontsize',16,'fontweight','bold');
axis([68 98 6 38])
set(gca,'XTick',68:5:98,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',6:5:38,'fontweight','bold')
ylabel('Latitude (^oN)','FontWeight','bold');
xlabel('Longitude (^oE)','FontWeight','bold');
colorbar;

% colorbar('FontSize',11,'YTick',log(C),'YTickLabel',C);
box on;