clc;clear all;close all;

cd /home/cas/phd/asz188660/scratch/solar_dim_bright/all_dot_mat_file
load CERES_LAND_RAD_all_sky_final

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load NDVI_GHSL_661_626.mat sara_lat sara_lon ndvi_2015 g_2015

for m=1:18
    ceres_all(:,:,m)=nanmean(CERES_LAND_RAD_final(:,:,(m-1)*12+1:(m*12)),3);
end

kk_mean(:,:)=nanmean(CERES_LAND_RAD_final,3);
% figure; geoshow(sara_lat, sara_lon, kk_mean,'DisplayType', 'Surface'); colorbar;

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load mask_state_wise.mat maskin

k2=kk_mean;
k2(k2<208.33)=NaN;
% ceres_all_sol=ceres_all;
% ceres_all_sol(ceres_all_sol<208.33)=NaN;
% % rad_trd_all_no_set_pos_ndvi(isnan(k2))=NaN;
% ceres_sol_pot_mean(:,:)=nanmean(ceres_all_sol,3);
% figure; geoshow(sara_lat, sara_lon, ceres_sol_pot_mean,'DisplayType', 'Surface'); colorbar;
%%
for k=1
    b1_total_all_year=ceres_all;
    for i=1:661 % longitude
        for j=1:626 % lattitude
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

k3=tren1_total_all_year;
k3(isnan(k2))=NaN;
k3(k3>0)=NaN;
%%
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load mask_state_wise.mat maskin
newcell=maskin;
%%
d2=reshape(k3,661*626,1);

%%
for i=1:36
    maskstate=newcell{i,1};
    [r1,c1]=find(maskstate==1);
    rad_pot_msk{i,1}=d2(r1,1);
    rad_pot_msk{i,2}=r1;
    clear r c1 maskstate 
    
end 


for i=1:36
    rad_pot_mean{i,1}=mean(rad_pot_msk{i,1},'omitNaN');
%     rad_2015_mean{i,2}=size(rad_2015_msk{i,1});
    i
    
end

for i=1:36
    aa2=cell2mat(rad_pot_msk(i,1));
    dd2=nnz(~isnan(aa2));
    cc2{i,1}=dd2;
    clear aa2 dd2 
    i
end