%% The influence of the sample size on the estimated quantile

%% Global Commands

clear;clc; % clear

% specify directoy for the files <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
directory=cd

%set global commands for font size and line width
size_font=9;
size_line=1.5;
set(0,'DefaultAxesFontSize',size_font,'DefaultTextFontSize',size_font);
set(0,'defaultlinelinewidth',size_line)

% figures
set(0, 'defaultFigurePaperType', 'A4')
set(0, 'defaultFigurePaperUnits', 'centimeters')
set(0, 'defaultFigurePaperPositionMode', 'auto')

% reset rngs before running
%rng(1)

%% Prices of MSFT (Weekly)

load data_nasdaq.mat

ret=ret_freq_nasdaq{20,1};

%% Parameters

% parameters under normality
mu_freq=mean(ret);%*251;
sigma_freq=std(ret);%*sqrt(251);

% stable parameters
para_stable_struct = fitdist(ret,'Stable');
alph=para_stable_struct.alpha;
beta=para_stable_struct.beta;
gamma=para_stable_struct.gam;%*251.^(1/alph);
delta=para_stable_struct.delta;% *251;

%% Simulate

alpha=1/10000;
n=10^7;

% Gaussian
ret_gauss_true=mu_freq+sigma_freq*randn(n,1); %10^8
% Student-T, nu=5
ret_t_true=mu_freq+sigma_freq*trnd(5,n,1);
% Stable
F_stable = makedist('Stable','alpha',alph,'beta',beta,'gam',gamma,'delta',delta);
ret_stable_true=random('Stable',alph,beta,gamma,delta,n,1);

% disrete returns
ret_gauss_discrete=exp(ret_gauss_true)-1;
ret_t_discrete=exp(ret_t_true)-1;
ret_stable_discrete=exp(ret_stable_true)-1;

% true quantiles
quantile_gauss_true=exp(icdf('Normal',alpha,mean(ret),std(ret)))-1
quantile_t_true=quantile(ret_t_discrete,alpha)
quantile_stable_true=exp(icdf('Stable',alpha,para_stable_struct.alpha,para_stable_struct.beta,...
    para_stable_struct.gam,para_stable_struct.delta))-1

%% Simulations

% m simulation runs for the quantile estimation
m=1000; %5000

quantile_gauss=zeros(m,1);
quantile_t=quantile_gauss;
quantile_stable=quantile_gauss;

% plot quantile_delta and quantile_quantile_diff as function of n
ii=0;
n_plot=floor(exp(0:0.5:12));
nn=length(n_plot);


quantile_delta_gauss=nan(1,nn);
quantile_delta_t=quantile_delta_gauss;
quantile_delta_stable=quantile_delta_gauss;

quantile_quantile_diff_gauss=quantile_delta_gauss;
quantile_quantile_diff_t=quantile_delta_gauss;
quantile_quantile_diff_stable=quantile_delta_gauss;

for n = 569%n_plot
    ii=ii+1

    for i=1:m

        ret_gauss=mu_freq+sigma_freq*randn(n,1);
        ret_t=mu_freq+sigma_freq*trnd(5,n,1);
        ret_stable=random('Stable',alph,beta,gamma,delta,n,1);

        ret_gauss_discrete=exp(ret_gauss)-1;
        ret_t_discrete=exp(ret_t)-1;
        ret_stable_discrete=exp(ret_stable)-1;

        quantile_gauss(i,:)=quantile(ret_gauss_discrete,alpha);
        quantile_t(i,:)=quantile(ret_t_discrete,alpha);
        quantile_stable(i,:)=quantile(ret_stable_discrete,alpha);
    end

    quantile_delta_gauss(ii)=quantile_gauss_true-mean(quantile_gauss);
    quantile_delta_t(ii)=quantile_t_true-mean(quantile_t);
    quantile_delta_stable(ii)=quantile_stable_true-mean(quantile_stable);

    alpha2=0.95;
    quantile_quantile_diff_gauss(ii)=quantile_gauss_true-quantile(quantile_gauss,alpha2);
    quantile_quantile_diff_t(ii)=quantile_t_true-quantile(quantile_t,alpha2);
    quantile_quantile_diff_stable(ii)=quantile_stable_true-quantile(quantile_stable,alpha2);

end





%% Plot quantile_delta and quantile_quantile_diff as function of n

h=figure();

subplot(2,1,1)
plot(n_plot,quantile_delta_gauss,'Color',[0 102 204]./255);hold on;
plot(n_plot,quantile_delta_t,'Color',[204 0 0]./255)
plot(n_plot,quantile_delta_stable,'Color',[0 204 102]./255)
xlim([min(n_plot) max(n_plot)]);
grid on
set(gca,'xscale','log')
xlabel('n','Interpreter','Latex')
ylabel('$$\bar{b}_n$$','Interpreter','Latex')

% find point where estimator is unbiased
i_first=10%find(quantile_delta_stable>0,1);


subplot(2,1,2)
plot(n_plot,quantile_quantile_diff_gauss,'Color',[0 102 204]./255);hold on;
plot(n_plot,quantile_quantile_diff_t,'Color',[204 0 0]./255)
plot(n_plot,quantile_quantile_diff_stable,'Color',[0 204 102]./255)
xlim([min(n_plot) max(n_plot)]); %xlim([n_plot(i_first) n_plot(end)])
grid on
set(gca,'xscale','log')
xlabel('n','Interpreter','Latex')
ylabel('$$O_n(\bar{\alpha})$$','Interpreter','Latex')

print(h,'-depsc','-r300','model_alpha01') %-depsc

%% Plot quantile distribution

h=figure();
range=quantile(quantile_stable,0.01):0.008:quantile(quantile_gauss,1);

max_counts=0.4;%max(counts/sum(counts));

line([quantile_gauss_true quantile_gauss_true],[max_counts 0],...
    'Color',[0 102 204]./255); hold on;
line([quantile_t_true quantile_t_true],[max_counts 0],...
    'Color',[204 0 0]./255)
line([quantile_stable_true quantile_stable_true],[max_counts 0],...
    'Color',[0 204 102]./255)


[counts2,centers2]=hist(quantile_gauss,range); 
bar(centers2,counts2/sum(counts2),'FaceColor',[0 102 204]./255)
[counts2,centers2]=hist(quantile_t,range); hold on;
bar(centers2,counts2/sum(counts2),'FaceColor',[204 0 0]./255)
[counts2,centers2]=hist(quantile_stable,range);
bar(centers2,counts2/sum(counts2),'FaceColor',[0 204 102]./255) %30

xlim([-0.4 -0.05]);

xlabel('Discrete return')
ylabel('Frequency')

print(h,'-depsc','-r300','model_dist01') %-depsc

%% Plot distributions on semilog-scale

h=figure();

range=-0.6:0.015:0.6;

[counts,centers]=hist(ret_gauss_true,range); hold on;
stairs(centers,counts/sum(counts),'Color',[0 102 204]./255)
[counts,centers]=hist(ret_t_true,range); hold on;
stairs(centers,counts/sum(counts),'Color',[204 0 0]./255)
[counts,centers]=hist(ret_stable_true,range); hold on;
stairs(centers,counts/sum(counts),'Color',[0 204 102]./255)

%[counts,centers]=hist(ret,range);
%stairs(centers,counts/sum(counts),'Color','k')

set(gca,'yscale','log')
ylim([10^-6 10^0])
xlim([-0.5 0.5])
xlabel('Weekly return')
ylabel('Frequency')
%print(h,'-depsc','-r300','model_hist_semilog') %-depsc

%% Hypothesis Test for the quantile
%{
quantile_difference=quantile_sim_true-quantile_estimated;
p_smaller=sum(quantile_difference<0)/m;
quantile_delta=quantile_sim_true-mean(quantile_estimated);
quantile_quantile=quantile(quantile_estimated,0.05);
interquartilerange=iqr(quantile_estimated);
%}





