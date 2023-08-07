%% first run variable_saving_4_ind_msked_radi_trd.m
clear all; close all; clc
cd '/home/cas/phd/asz188660/scratch/solar_dim_bright/all_dot_mat_file'

load('ann_trend_all_clr_noaero_rad.mat')

m_trd_all_sky=nanmean(trd_all_SON_sky_india)
std_trd_all_sky=nanstd(trd_all_SON_sky_india)
all_sky_dimm_trd=(sum(trd_all_SON_sky_india<0)./308).*100

m_trd_clr_sky=nanmean(trd_clr_SON_sky_india)
std_trd_clr_sky=nanstd(trd_clr_SON_sky_india)
clr_sky_dimm_trd=(sum(trd_clr_SON_sky_india<0)./308).*100

m_trd_naer_sky=nanmean(trd_naer_SON_sky_india)
std_trd_naer_sky=nanstd(trd_naer_SON_sky_india)
naer_sky_dimm_trd=(sum(trd_naer_SON_sky_india<0)./308).*100

%%
figure
set(gcf,'color','white');
p1=cdfplot(trd_all_ann_sky_india);
set( p1, 'LineWidth', 5, 'Color', 'b');
hold on
p2=cdfplot(trd_clr_SON_sky_india);
set( p2, 'LineWidth', 5, 'Color', 'r');
p3=cdfplot(trd_naer_SON_sky_india);
set( p3, 'LineWidth', 5, 'Color', 'm');
y1=xline(mean(trd_all_SON_sky_india),'-.b',{' '},'fontsize',10,'FontWeight','bold','LineWidth',2.5);
x1=xline(mean(trd_clr_SON_sky_india),'-.r',{' '},'fontsize',10,'FontWeight','bold','LineWidth',2.5);
z1=xline(mean(trd_naer_SON_sky_india),'-.m',{' '},'fontsize',10,'FontWeight','bold','LineWidth',2.5);
t1=xline(0,'-k',{' '},'fontsize',10,'FontWeight','bold','LineWidth',2.5);
% xline(4.5,'-',{'Acceptable','Limit'});
grid on
% legend('2k01 to 2k09','2k10 to 2k19','2k01 to 2k19')
ylabel ('CDF','fontsize',18,'FontWeight','bold')
xlabel ('W/m^2 per year','fontsize',18,'FontWeight','bold')
set(gca,'XTick',-2.5:0.5:2.5,'fontsize',18,'fontweight','bold','LineWidth',2.5)
title('Trend: Per year ')
xlim([-2.5 2.5])
