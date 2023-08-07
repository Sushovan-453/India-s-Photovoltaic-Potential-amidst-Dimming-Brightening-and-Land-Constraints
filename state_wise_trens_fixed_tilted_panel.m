clc;clear all;close all;
cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load suitable_grid_pts.mat sara_lon sara_lat g_combined

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load CERES_LAND_RAD_all_sky_fix_final.mat CERES_LAND_RAD_all_sky_fix_final 
load CERES_LAND_RAD_naer_sky_fix_final.mat CERES_LAND_RAD_naer_sky_fix_final 

%% trend calculation

for k=1
    b1_total_all_year=CERES_LAND_RAD_all_sky_fix_final;
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
%% impolygon function 
s=shaperead('/home/cas/phd/asz188660/scratch/asp_731_project/Admin2.shp');

cd '/scratch/cas/phd/asz188660/solar_dim_bright/all_dot_mat_file'
load mask_state_wise.mat maskin

%%
d1=reshape(tren1_total_all_year,661*626,1);

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
%%




