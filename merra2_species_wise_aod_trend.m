%% CODE FOR merra2 species wise aod

clear all; clc; close all;
f_merra2='/home/cas/phd/asz188660/scratch/solar_dim_bright/aod_spec_merra2/MERRA2_400.tavgM_2d_aer_Nx.200012_to_201912.SUB.nc';

lat_data=ncread(f_merra2,'lat');
lon_data=ncread(f_merra2,'lon');
bc=ncread(f_merra2,'BCEXTTAU');
oc=ncread(f_merra2,'OCEXTTAU');
dust=ncread(f_merra2,'DUEXTTAU');
sul=ncread(f_merra2,'SUEXTTAU');

%% 2001 to 2018
bc=bc(:,:,2:217);
oc=oc(:,:,2:217);
dust=dust(:,:,2:217);
sul=sul(:,:,2:217);

%% annual climatology

for k=1:18
    
    for m=1:57
        
        for n=1:71
            
            bc_Ann(m,n,k)=nanmean(bc(m,n,((k-1)*12+1):(k)*12),3);
            oc_Ann(m,n,k)=nanmean(oc(m,n,((k-1)*12+1):(k)*12),3);
            dust_Ann(m,n,k)=nanmean(dust(m,n,((k-1)*12+1):(k)*12),3);
            sul_Ann(m,n,k)=nanmean(sul(m,n,((k-1)*12+1):(k)*12),3);
            
        end
    end
end

%% bc aot extinction 

for k=1
    b1_bc_year=bc_Ann;
    for i=1:57 % longitude
        for j=1:71 % lattitude
            x=[1:18]'; %%%[number of years]
            y_bc_year=reshape(b1_bc_year(i,j,:),18,1);
            if (isnan(y_bc_year))
                tren1_bc_year(i,j)=NaN;
                pval1_bc_year(i,j)=NaN;
            else
                stats_bc_year=regstats(y_bc_year,x,'linear');
                tren1_bc_year(i,j)=stats_bc_year.tstat.beta(2,1);
                pval1_bc_year(i,j)=stats_bc_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_bc_year
end
clear k
size(tren1_bc_year)
size(pval1_bc_year)

%% oc aot extinction 

for k=1
    b1_oc_year=oc_Ann;
    for i=1:57 % longitude
        for j=1:71 % lattitude
            x=[1:18]'; %%%[number of years]
            y_oc_year=reshape(b1_oc_year(i,j,:),18,1);
            if (isnan(y_oc_year))
                tren1_oc_year(i,j)=NaN;
                pval1_oc_year(i,j)=NaN;
            else
                stats_oc_year=regstats(y_oc_year,x,'linear');
                tren1_oc_year(i,j)=stats_oc_year.tstat.beta(2,1);
                pval1_oc_year(i,j)=stats_oc_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_oc_year
end
clear k
size(tren1_oc_year)
size(pval1_oc_year)
%% dust aot extinction 

for k=1
    b1_dust_year=dust_Ann;
    for i=1:57 % longitude
        for j=1:71 % lattitude
            x=[1:18]'; %%%[number of years]
            y_dust_year=reshape(b1_dust_year(i,j,:),18,1);
            if (isnan(y_dust_year))
                tren1_dust_year(i,j)=NaN;
                pval1_dust_year(i,j)=NaN;
            else
                stats_dust_year=regstats(y_dust_year,x,'linear');
                tren1_dust_year(i,j)=stats_dust_year.tstat.beta(2,1);
                pval1_dust_year(i,j)=stats_dust_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_dust_year
end
clear k
size(tren1_dust_year)
size(pval1_dust_year)

%% sul aot extinction 

for k=1
    b1_sul_year=sul_Ann;
    for i=1:57 % longitude
        for j=1:71 % lattitude
            x=[1:18]'; %%%[number of years]
            y_sul_year=reshape(b1_sul_year(i,j,:),18,1);
            if (isnan(y_sul_year))
                tren1_sul_year(i,j)=NaN;
                pval1_sul_year(i,j)=NaN;
            else
                stats_sul_year=regstats(y_sul_year,x,'linear');
                tren1_sul_year(i,j)=stats_sul_year.tstat.beta(2,1);
                pval1_sul_year(i,j)=stats_sul_year.tstat.pval(2,1);
                clear x y b bint r rint
            end
        end
%         i
    end
    clear i j b1_sul_year
end
clear k
size(tren1_sul_year)
size(pval1_sul_year)

%% regridding the climatology % @ 0.25 deg horizontal resolution

[X1,Y1] = meshgrid(6.5:0.25:39.5,65.5:0.25:99.5);
  lon_data1 = 65.5:0.25:99.5;
  lat_data1 = 6.5:0.25:39.5;

for i=1:1
        tren1_bc_inter_1(:,:)= interpn(lon_data,lat_data,tren1_bc_year(:,:,i),Y1, X1,'linear');
        tren1_bc_regrid(:,:,i)=tren1_bc_inter_1(:,:);
        
        tren1_oc_inter_1(:,:)= interpn(lon_data,lat_data,tren1_oc_year(:,:,i),Y1, X1,'linear');
        tren1_oc_regrid(:,:,i)=tren1_oc_inter_1(:,:);
        
        tren1_dust_inter_1(:,:)= interpn(lon_data,lat_data,tren1_dust_year(:,:,i),Y1, X1,'linear');
        tren1_dust_regrid(:,:,i)=tren1_dust_inter_1(:,:);
        
        tren1_sul_inter_1(:,:)= interpn(lon_data,lat_data,tren1_sul_year(:,:,i),Y1, X1,'linear');
        tren1_sul_regrid(:,:,i)=tren1_sul_inter_1(:,:);
        
        pval1_bc_inter_1(:,:)= interpn(lon_data,lat_data,pval1_bc_year(:,:,i),Y1, X1,'linear');
        pval1_bc_regrid(:,:,i)=pval1_bc_inter_1(:,:);
        
        pval1_oc_inter_1(:,:)= interpn(lon_data,lat_data,pval1_oc_year(:,:,i),Y1, X1,'linear');
        pval1_oc_regrid(:,:,i)=pval1_oc_inter_1(:,:);
        
        pval1_dust_inter_1(:,:)= interpn(lon_data,lat_data,pval1_dust_year(:,:,i),Y1, X1,'linear');
        pval1_dust_regrid(:,:,i)=pval1_dust_inter_1(:,:);
        
        pval1_sul_inter_1(:,:)= interpn(lon_data,lat_data,pval1_sul_year(:,:,i),Y1, X1,'linear');
        pval1_sul_regrid(:,:,i)=pval1_sul_inter_1(:,:);
end
 
%% masking over Indian regions

w = shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp');
lon_data_regrided = lon_data1;
lat_data_regrided = lat_data1;
cd '/home/cas/phd/asz188660/scratch/asp_731_project'

msk_tr_bc_regrid= maskregion(lon_data_regrided,lat_data_regrided,tren1_bc_regrid,w);
msk_tr_oc_regrid= maskregion(lon_data_regrided,lat_data_regrided,tren1_oc_regrid,w);
msk_tr_dust_regrid= maskregion(lon_data_regrided,lat_data_regrided,tren1_dust_regrid,w);
msk_tr_sul_regrid= maskregion(lon_data_regrided,lat_data_regrided,tren1_sul_regrid,w);

msk_pv_bc_regrid= maskregion(lon_data_regrided,lat_data_regrided,pval1_bc_regrid,w);
msk_pv_oc_regrid= maskregion(lon_data_regrided,lat_data_regrided,pval1_oc_regrid,w);
msk_pv_dust_regrid= maskregion(lon_data_regrided,lat_data_regrided,pval1_dust_regrid,w);
msk_pv_sul_regrid= maskregion(lon_data_regrided,lat_data_regrided,pval1_sul_regrid,w);

save aod_species.mat 'msk_tr_bc_regrid' 'msk_tr_oc_regrid' 'msk_tr_dust_regrid' 'msk_tr_sul_regrid' 'msk_pv_bc_regrid' 'msk_pv_oc_regrid' 'msk_pv_dust_regrid' 'msk_pv_sul_regrid'
%%
cd '/home/cas/phd/asz188660/scratch/asp_731_project'
load aod_species.mat
lon_data1 = 65.5:0.25:99.5;
lat_data1 = 6.5:0.25:39.5;
lon_data_regrided = lon_data1;
lat_data_regrided = lat_data1;
%%
FigH1=figure
set(gcf,'color','white');
bottom=-0.003;
top=0.003;
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
colormap(brewermap([],'*RdBu'))
h=pcolor(lon_data_regrided,lat_data_regrided,msk_tr_sul_regrid');
set(h, 'EdgeColor', 'none');
caxis manual; caxis([bottom top]);
shading interp;
hold on;
geoshow('/home/cas/phd/asz188660/scratch/CMIP6_HISTO_AOD_550/ALL_DOT_m_files_for_cmip6/India_Boundary.shp','FaceColor','none','linewidth',1);
geoshow('/home/cas/phd/asz188660/scratch/asp_731_project/world_map_10_01_17.shp','Color','k','linewidth',0.5);
StatisticallySignificant = msk_pv_sul_regrid<= 0.05;
[Lon1,Lat1] = meshgrid(lon_data_regrided,lat_data_regrided);
hold on
title('Sulfate trend','fontsize',14,'fontweight','bold');
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
stipple(Lon1,Lat1,StatisticallySignificant','color','k','marker','.','markersize',6)
axis([66 99 6 39])
set(gca,'XTick',65:5:100,'fontweight','bold','linewidth',1.5)
set(gca,'YTick',5:5:40,'fontweight','bold')
ylabel('lat(^oN)','FontWeight','bold');
xlabel('lon(^oE)','FontWeight','bold');
colorbar('southoutside')
cd('/home/cas/phd/asz188660/scratch/asp_731_project')
cbarrow;
clear Lon1 Lat1 StatisticallySignificant 
% cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm'
% saveas(FigH1, 'sulfate_ann_trend.png','png');       

%%

        
