clc; clear all; close all;

ceres_f='/home/cas/phd/asz188660/scratch/solar_dim_bright/CERES_SYN1deg-Month_Terra-Aqua-MODIS_Ed4.1_Subset_200012-201912.nc';

modis_clf='/home/cas/phd/asz188660/scratch/solar_dim_bright/modis_terra_mon/MOD08_M3_6_1_Cloud_Fraction_Mean_Mean.20010101_20181201.64E_4N_100E_40N.nc';
clf_1=ncread(modis_clf,'MOD08_M3_6_1_Cloud_Fraction_Mean_Mean');


modis_aod='/home/cas/phd/asz188660/scratch/solar_dim_bright/modis_aod/modis_aod_200101_202012.nc';
aod_1=ncread(ceres_f,'ini_aod55_mon');
aod=aod_1(:,:,2:217);
lat_data=ncread(ceres_f,'lat');
lon_data=ncread(ceres_f,'lon');

dir_clr=ncread(ceres_f,'adj_sfc_sw_direct_clr_mon');
diff_clr=ncread(ceres_f,'adj_sfc_sw_diff_clr_mon');

dir_naer=ncread(ceres_f,'adj_sfc_sw_direct_naer_mon');
diff_naer=ncread(ceres_f,'adj_sfc_sw_diff_naer_mon');

dir_all=ncread(ceres_f,'adj_sfc_sw_direct_all_mon');
diff_all=ncread(ceres_f,'adj_sfc_sw_diff_all_mon');

tot_all_1=dir_all+diff_all;
tot_all=tot_all_1(:,:,2:217);
tot_clr_1=dir_clr+diff_clr;
tot_clr=tot_clr_1(:,:,2:217);
tot_naer_1=dir_naer+diff_naer;
tot_naer=tot_naer_1(:,:,2:217);

clf=clf_1(2:end,2:end,:);
aero_impact=(tot_naer-tot_all);
cld_impact=(tot_clr-tot_all);


%% annual climatology

for k=1:18

    for m=1:35

        for n=1:35

            tot_rad_all_Ann(m,n,k)=nanmean(tot_all(m,n,((k-1)*12+1):(k)*12),3);
            tot_rad_naer_Ann(m,n,k)=nanmean(tot_naer(m,n,((k-1)*12+1):(k)*12),3);
            tot_rad_clr_Ann(m,n,k)=nanmean(tot_clr(m,n,((k-1)*12+1):(k)*12),3);
            cld_impac_Ann(m,n,k)=nanmean(cld_impact(m,n,((k-1)*12+1):(k)*12),3);
            aero_impac_Ann(m,n,k)=nanmean(aero_impact(m,n,((k-1)*12+1):(k)*12),3);
            cld_frac_Ann(m,n,k)=nanmean(clf(m,n,((k-1)*12+1):(k)*12),3);
            aod_Ann(m,n,k)=nanmean(aod(m,n,((k-1)*12+1):(k)*12),3);
        end
    end
end
%%
cd /home/cas/phd/asz188660/scratch/solar_dim_bright/matlab_file_dimming_trend
% 65E, 6.5N
cld_imp_ann_2k1_18=cld_impac_Ann(:,2:end,:);
cld_frac_ann_2k1_18=cld_frac_Ann(:,2:end,:);
aero_imp_ann_2k1_18=aero_impac_Ann(:,2:end,:);
aod_ann_2k1_18=aod_Ann(:,2:end,:);

%%
cld_fr_indu=cld_imp_ann_2k1_18./exp(cld_frac_ann_2k1_18);
aod_indu=aero_imp_ann_2k1_18./exp(aod_ann_2k1_18);

%% trend
for k=1
    b1_aero_impac_year=aod_indu;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_aero_impac_year=reshape(b1_aero_impac_year(i,j,:),18,1);
            if (isnan(y_aero_impac_year))
                tren1_aero_impac_year(i,j)=NaN;
                pval1_aero_impac_year(i,j)=NaN;
            else
                stats_aero_impac_year=regstats(y_aero_impac_year,x,'linear');
                tren1_aero_impac_year(i,j)=stats_aero_impac_year.tstat.beta(2,1);
                pval1_aero_impac_year(i,j)=stats_aero_impac_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_aero_impac_year
end
clear k
%%

%% cloud impact

for k=1
    b1_cld_impac_year=cld_fr_indu;
    for i=1:35 % longitude
        for j=1:34 % lattitude
            x=[1:18]'; %%%[number of years]
            y_cld_impac_year=reshape(b1_cld_impac_year(i,j,:),18,1);
            if (isnan(y_cld_impac_year))
                tren1_cld_impac_year(i,j)=NaN;
                pval1_cld_impac_year(i,j)=NaN;
            else
                stats_cld_impac_year=regstats(y_cld_impac_year,x,'linear');
                tren1_cld_impac_year(i,j)=stats_cld_impac_year.tstat.beta(2,1);
                pval1_cld_impac_year(i,j)=stats_cld_impac_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_cld_impac_year
end
clear k
%%
lon_data_regrided=lon_data;
lat_data_regrided=lat_data(2:end);
FigH1=figure;
set(gcf,'color','white');
bottom=-0.15;
top=0.15;
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
colormap(brewermap([],'*RdBu'))
h=pcolor(lon_data_regrided,lat_data_regrided,tren1_aero_impac_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
shading interp;
hold on;
geoshow('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',1);
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/world_map_10_01_17.shp','Color','k','linewidth',0.5);
StatisticallySignificant = pval1_aero_impac_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_data_regrided,lat_data_regrided);
hold on
title('Aerosol induced trend','fontsize',16,'fontweight','bold');
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
stipple(Lon1,Lat1,StatisticallySignificant','color','k','marker','.','markersize',6)
axis([66 99 6 39])
set(gca,'XTick',65:5:100,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',5:5:40,'fontweight','bold')
ylabel('lat(^oN)','FontWeight','bold');
xlabel('lon(^oE)','FontWeight','bold');
colorbar;
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
cbarrow;
clear Lon1 Lat1 StatisticallySignificant
cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm/direct'
saveas(FigH1, 'aerosol_induced_trend.png','png');

%%
FigH2=figure;
set(gcf,'color','white');
bottom=-0.35;
top=0.35;
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
colormap(brewermap([],'*RdBu'))
h=pcolor(lon_data_regrided,lat_data_regrided,tren1_cld_impac_year');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
shading interp;
hold on;
geoshow('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',1);
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/world_map_10_01_17.shp','Color','k','linewidth',0.5);
StatisticallySignificant = pval1_cld_impac_year<= 0.05;
[Lon1,Lat1] = meshgrid(lon_data_regrided,lat_data_regrided);
hold on
title('Cloud induced trend','fontsize',16,'fontweight','bold');
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
stipple(Lon1,Lat1,StatisticallySignificant','color','k','marker','.','markersize',6)
axis([66 99 6 39])
set(gca,'XTick',65:5:100,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',5:5:40,'fontweight','bold')
ylabel('lat(^oN)','FontWeight','bold');
xlabel('lon(^oE)','FontWeight','bold');
colorbar;
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
cbarrow;
clear Lon1 Lat1 StatisticallySignificant
cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm/direct'
saveas(FigH2, 'cloud_induced_trend.png','png');

%% climatology plot
aero_induc_clim(:,:)=nanmean(aod_indu,3);
FigH5=figure;
set(gcf,'color','white');
bottom=2;
top=20;
colormap(turbo);
h1=pcolor(lon_data_regrided,lat_data_regrided,aero_induc_clim');
set(h1,'EdgeColor','none')
caxis manual
caxis([bottom top]);
shading interp;
hold on;
% geoshow('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',1);
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/world_map_10_01_17.shp','Color','k','linewidth',0.5);
title('Aerosol induced Clim','fontsize',12,'fontweight','bold');
axis([66 99 6 39])
set(gca,'XTick',65:5:100,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',5:5:40,'fontweight','bold')
ylabel('lat(^oN)','FontWeight','bold');
xlabel('lon(^oE)','FontWeight','bold');
colorbar;
cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm/direct'
saveas(FigH5, 'Aerosol_induced_clim.png','png');

%%
cld_frac_induc_clim(:,:)=nanmean(cld_fr_indu,3);
FigH6=figure;
set(gcf,'color','white');
bottom=5;
top=60;
colormap(turbo);
h1=pcolor(lon_data_regrided,lat_data_regrided,cld_frac_induc_clim');
set(h1,'EdgeColor','none')
caxis manual
caxis([bottom top]);
shading interp;
hold on;
% geoshow('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',1);
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/world_map_10_01_17.shp','Color','k','linewidth',0.5);
title('Cloud induced Clim','fontsize',12,'fontweight','bold');
axis([66 99 6 39])
set(gca,'XTick',65:5:100,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',5:5:40,'fontweight','bold')
ylabel('lat(^oN)','FontWeight','bold');
xlabel('lon(^oE)','FontWeight','bold');
colorbar;
cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm/direct'
saveas(FigH6, 'Cloud_induced_clim.png','png');
