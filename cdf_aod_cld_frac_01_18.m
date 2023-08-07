
clear all; close all; clc;
cd /home/cas/phd/asz188660/scratch/solar_dim_bright/all_dot_mat_file
load masked_all_variable.mat

for i=1:18
    a_aod=masked_aod_Ann_regrid(:,:,i);
    aa_aod(:,i)=reshape(a_aod,[],1);
    
    a_cld_frac=masked_cld_frac_Ann_regrid(:,:,i);
    aa_cld_frac(:,i)=reshape(a_cld_frac,[],1);
    
end
out_aod = aa_aod(all(~isnan(aa_aod),2),:);
out_cld_frac = aa_cld_frac(all(~isnan(aa_cld_frac),2),:);
%%
out_aod_mean=nanmean(out_aod);
out_cld_frac_m=nanmean(out_cld_frac);
%%
y_val = out_cld_frac;
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
cd /home/cas/phd/asz188660/scratch/solar_dim_bright/figures_solar_dimm/cdf_gif_plot
filename = 'solar_cld_frac_pmrf_cdf.gif';
t = 1:1:18; %year
A = 18; %number of plots
colormap(jet(18))
jetcustom = jet(18);
% figure
set(gcf,'color','white');
YEAR=[2001:1:2018];
%%
for H = 1:A
       colormap(jet(18))
         caxis([0 18])
        colorbar('Ticks',t(H),'LineWidth',2.5,'TickLength',0.03,...
         'TickLabels',YEAR(H),'FontSize',16,'fontweight','bold')
        p=cdfplot(y_val(:,H));
        set(p,'Color',  jetcustom(H,:),'LineWidth',2.5)
        hold on
        ylim([0 1])
        xlim([0 1])
        ylabel ('CDF','fontsize',14,'FontWeight','bold')
        xlabel (' ','fontsize',14,'FontWeight','bold')
        set(gca,'XTick',0:0.2:1,'fontsize',18,'fontweight','bold','linewidth',2.5)
        title('')
        grid on

    y1=xline(mean(y_val(:,H)))
    set(y1,'Color',jetcustom(H,:),'LineWidth',2.5)
    drawnow

      % Capture the plot as an image 
      frame = getframe(h);
      im = frame2im(frame);
      [imind,cm] = rgb2ind(im,256);

      % Write to the GIF File 
      if H == 1
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
      else
          imwrite(imind,cm,filename,'gif','WriteMode','append');
      end
end


