%% function to create magnitude plots of the loop transfer function
% checkloopshape(L,Llbd,wlbd,Lubd,wubd)
% inputs:   L -> loop transfer function (must be siso!)
%           Llbd -> in db, lower bound for the loop gain at low frequencies
%           wlbd -> in rad/s, frequency below which |L| shall be larger than |Llbd|
%           Lubd -> in db, upper bound for the loop gain at high frequencies
%           wubd -> in rad/s, frequency above which |L| shall be less than |Lubd|
% outputs:  figure only

% This function is provided as part of the term project for the class
% "Flight Control Law Design and Application" at TU Hamburg.
% by Julian Theis and Nicolas Sedlmair, 2021

function []=checkloopshape(L,Llbd,wlbd,Lubd,wubd)

% ------ preparations ----------

log_min = -2;
log_max = 3;

Ts = L.Ts;
if Ts ~= 0
    w_sample = pi/Ts; 
    log_max = log10(w_sample);
end

xmin = 10^(log_min);
xmax = 10^(log_max);
ymin = -50;
ymax = 50;

Nw = 1000;
w = logspace(log_min,log_max,Nw)';
Lmag = bode(L,w);
Lmag = Lmag(:);
LmagdB = 20*log10(Lmag);
[~,Lidx] = min(abs(LmagdB));
wL = w(Lidx);

idx = (w >= wubd);
idxwubd = find(idx,1,'first');

% ------------------------------

% semilogx(w,LmagdB,'k','LineWidth',0.5);
semilogx(w,LmagdB,'LineWidth',0.5);
hold on;
axis([xmin xmax ymin ymax]);
semilogx([w(1) w(end)],[0 0],'k');
lhL = semilogx([wL wL xmin],[ymin 0 0],'k:');
% phLclb  = patch([wL/sqrt(10) wL  wL*sqrt(10) wL*sqrt(10) wL wL/sqrt(10)], [10 0 -15 ymin ymin ymin],'g');
% phLcub  = patch([wL/sqrt(10) wL  wL*sqrt(10) wL*sqrt(10) wL wL/sqrt(10)], [15 0 -10 ymax ymax ymax],'g');
semilogx([wL/sqrt(10) wL  wL*sqrt(10)],[10 0 -15],'g--');
semilogx([wL/sqrt(10) wL  wL*sqrt(10)],[15 0 -10],'g--');
% phLlb = patch([w(1) wlbd wlbd w(1)],[ymin ymin Llbd Llbd],'b');
% phLub = patch([w(end) wubd wubd w(end)],[ymax ymax Lubd LmagdB(idxwubd)-20],'r');
semilogx([w(1) wlbd],[Llbd Llbd],'b');
semilogx([wlbd wlbd],[ymin Llbd],'b');
semilogx([wubd w(end)],[Lubd -40],'r');
semilogx([wubd wubd],[Lubd ymax],'r');
% set(phLlb,'FaceAlpha',0.15,'LineStyle','none');
% set(phLub,'FaceAlpha',0.15,'LineStyle','none');
% set(phLclb,'FaceAlpha',0.15,'LineStyle','none');
% set(phLcub,'FaceAlpha',0.15,'LineStyle','none');
xlabel('Frequency [rad/s]');
ylabel('Open loop |L| [dB]');
hold off
