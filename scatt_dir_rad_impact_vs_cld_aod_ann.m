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
cld_imp_ann_2k1_18_ind = zone_wise_Indian_region(cld_imp_ann_2k1_18);

cld_frac_ann_2k1_18=cld_frac_Ann(:,2:end,:);
cld_frac_ann_2k1_18_ind = zone_wise_Indian_region(cld_frac_ann_2k1_18);

aero_imp_ann_2k1_18=aero_impac_Ann(:,2:end,:);
aero_imp_ann_2k1_18_ind = zone_wise_Indian_region(aero_imp_ann_2k1_18);

aod_ann_2k1_18=aod_Ann(:,2:end,:);
aod_ann_2k1_18_ind = zone_wise_Indian_region(aod_ann_2k1_18);
%%

[xData_cf, yData_cld_imp] = prepareCurveData( cld_frac_ann_2k1_18_ind, cld_imp_ann_2k1_18_ind );

% Set up fittype and options.
ft_cf = fittype( 'a*exp(b*x)', 'independent', 'x', 'dependent', 'y' );
opts_cf = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts_cf.Display = 'Off';
opts_cf.StartPoint = [0.462406689325883 0.151465910526612];

% Fit model to data.
[fitresult_cf, gof_cf] = fit( xData_cf, yData_cld_imp, ft_cf, opts_cf )

figure1=figure;
set(gcf,'Color','w');
plt=plot(xData_cf,yData_cld_imp,'.b');
hold on
xlim([0 1]);
xticks([0:0.2:1])
ylim([0 200])
yticks(0:20:200)
pbd=plot(fitresult_cf,'predobs');
set(pbd,'LineWidth',2,'LineStyle',':','Color',[0.6350 0.0780 0.1840]);
fit_l=plot(fitresult_cf);
set(fit_l, 'LineWidth',2.5,'Color',[0.6350 0.0780 0.1840]);
set(gca,'FontSize',16, 'fontweight','bold','LineWidth',2)
grid on
xlabel('')
ylabel ('')
legend off
%%
[xData_aod, yData_aero_imp] = prepareCurveData( aod_ann_2k1_18_ind, aero_imp_ann_2k1_18_ind );

% Set up fittype and options.
ft_cf = fittype( 'a*exp(b*x)', 'independent', 'x', 'dependent', 'y' );
opts_cf = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts_cf.Display = 'Off';
opts_cf.StartPoint = [0.462406689325883 0.151465910526612];

% Fit model to data.
[fitresult_aod, gof_aod] = fit( xData_aod, yData_aero_imp, ft_cf, opts_cf )

figure2=figure;
set(gcf,'Color','w');
plt=plot(xData_aod,yData_aero_imp,'.m');
hold on
xlim([0 1.4]);
xticks([0:0.2:1.4]);
ylim([0 200])
yticks(0:20:200)
pbd=plot(fitresult_aod,'predobs');
set(pbd,'LineWidth',2,'LineStyle',':','Color',[0 0.4470 0.7410]);
fit_l=plot(fitresult_aod);
set(fit_l, 'LineWidth',2.5,'Color',[0 0.4470 0.7410]);
set(gca,'FontSize',16, 'fontweight','bold','LineWidth',2)
grid on
xlabel('')
ylabel ('')
legend off

cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm/exp_plt'
saveas(figure1, 'cld_impct_vs_cld_frac_ann.png','png');
cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm/exp_plt'
saveas(figure2, 'aero_impct_vs_aod_ann.png','png');

