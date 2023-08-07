
clc;clear all; close all;
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'

load suitable_grid_pts.mat sara_lon sara_lat g_combined

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load mask_state_wise.mat maskin
ss=shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp');
%%
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load  CERES_LAND_RAD_all_sky_final.mat CERES_LAND_RAD_final
all_sky_rad=CERES_LAND_RAD_final;

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load CERES_LAND_RAD_naer_sky_final.mat CERES_LAND_RAD_final
naer_sky_rad=CERES_LAND_RAD_final;
clear CERES_LAND_RAD_final
aerosol_impac=naer_sky_rad-all_sky_rad;

all_sky_rad_w_o_aero=all_sky_rad+aerosol_impac;



for k=1:18
    CERES_FINAL_REGRID_ANN(:,:,k)=nanmean(all_sky_rad_w_o_aero(:,:,(((k-1)*12+1):(k*12))),3);
end

CERES_FINAL_REGRID_CLIM=nanmean(CERES_FINAL_REGRID_ANN,3);

CERES_FINAL_REGRID_CLIM_land=CERES_FINAL_REGRID_CLIM;
CERES_FINAL_REGRID_CLIM_land(isnan(g_combined))=NaN;
CERES_FINAL_REGRID_CLIM_land(CERES_FINAL_REGRID_CLIM_land<208)=NaN;

%%
sara_lon_dummy=sara_lon;
sara_lat_dummy=sara_lat;
% % sara_lon_dummy(isnan(g_combined))=NaN;
% % sara_lat_dummy(isnan(g_combined))=NaN;
sara_lon_dummy(isnan(CERES_FINAL_REGRID_CLIM_land))=NaN;
sara_lat_dummy(isnan(CERES_FINAL_REGRID_CLIM_land))=NaN;
%%

for i=1:36
    a=cell2mat(maskin(i,1));
    b=reshape(a,661,626);
    c=sara_lat_dummy;
    d=sara_lon_dummy;
    c(b==0)=NaN;
    d(b==0)=NaN;
    e{i,1}=c;
    e{i,2}=d;
    clear a b c d 
    i
end

for i=1:36
    aa=cell2mat(e(i,1));
    bb=cell2mat(e(i,2));
    dd=nnz(~isnan(aa));
    ee=nnz(~isnan(bb));
    cc{i,1}=dd;
    cc{i,2}=ee;
    clear aa dd bb ee
    i
end






