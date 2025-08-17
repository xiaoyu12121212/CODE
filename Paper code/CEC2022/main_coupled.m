clc
clear
close all

npop = 30; 
Max_iter = 500; 
dim = 10; 

ii = 7;
Function_name = ii;
[lb, ub, dim, fobj] = Get_Functions_cec2022(ii, dim);

n1 = [];
n2 = [];
n3 = [];
n4 = [];
n5 = [];
n6 = [];
n7 = [];

theta = 3;
rho = 4;

for i = 1: 30

    [Bestscore1, Best_pos1, curve1] = ZOA(npop, Max_iter, lb, ub, dim, fobj);
    [Bestscore2, Best_pos2, curve2] = cou_ZOA(npop, Max_iter, lb, ub, dim, fobj, 1, theta);
    [Bestscore3, Best_pos3, curve3] = cou_ZOA(npop, Max_iter, lb, ub, dim, fobj, 1, rho);
    [Bestscore4, Best_pos4, curve4] = cou_ZOA(npop, Max_iter, lb, ub, dim, fobj, 2, theta);
    [Bestscore5, Best_pos5, curve5] = cou_ZOA(npop, Max_iter, lb, ub, dim, fobj, 2, rho);
    [Bestscore6, Best_pos6, curve6] = cou_ZOA(npop, Max_iter, lb, ub, dim, fobj, 3, theta);
    [Bestscore7, Best_pos7, curve7] = cou_ZOA(npop, Max_iter, lb, ub, dim, fobj, 3, rho);


    c1(i, :) = curve1;
    c2(i, :) = curve2;
    c3(i, :) = curve3;
    c4(i, :) = curve4;
    c5(i, :) = curve5;
    c6(i, :) = curve6;
    c7(i, :) = curve7;


    n1(end+1) = Bestscore1;
    n2(end+1) = Bestscore2;
    n3(end+1) = Bestscore3;
    n4(end+1) = Bestscore4;
    n5(end+1) = Bestscore5;
    n6(end+1) = Bestscore6;
    n7(end+1) = Bestscore7;


end

ave1 = mean(n1);
ave2 = mean(n2);
ave3 = mean(n3);
ave4 = mean(n4);
ave5 = mean(n5);
ave6 = mean(n6);
ave7 = mean(n7);


s1 = std(n1);
s2 = std(n2);
s3 = std(n3);
s4 = std(n4);
s5 = std(n5);
s6 = std(n6);
s7 = std(n7);


min1 = min(n1);
min2 = min(n2);
min3 = min(n3);
min4 = min(n4);
min5 = min(n5);
min6 = min(n6);
min7 = min(n7);


curve1 = mean(c1,1);
curve2 = mean(c2,1);
curve3 = mean(c3,1);
curve4 = mean(c4,1);
curve5 = mean(c5,1);
curve6 = mean(c6,1);
curve7 = mean(c7,1);


figure('position', [500, 100, 900, 750]);
semilogy(curve1,    'color','r', 'linestyle', '-', 'linewidth', 1.5,'Marker','o',...
                                           'markerindices',(1:50:500),'MarkerSize',8)
hold on
semilogy(curve2,   'color','c', 'linestyle', '-', 'linewidth', 1.5,'Marker','*',...
                                           'MarkerIndices',(1:50:500),'MarkerSize',8)
hold on
semilogy(curve3,   'color','m', 'linestyle', '--', 'linewidth', 1.5,'Marker','+',...
                                           'markerindices',(1:50:500),'MarkerSize',8)
hold on
semilogy(curve4,   'color','k', 'linestyle', ':', 'linewidth', 1.5,'Marker','^',...
                                           'markerindices',(1:50:500),'MarkerSize',8)
hold on
semilogy(curve5, 'color','b', 'linestyle', '-', 'linewidth', 1.5,'Marker','s',...
                                           'MarkerIndices',(1:50:500),'MarkerSize',8)
hold on
semilogy(curve6,    'color','g', 'linestyle', '-.', 'linewidth', 1.5,'Marker','x',...
                                           'markerindices',(1:50:500),'MarkerSize',8)
hold on
semilogy(curve7,    'color','y', 'linestyle', '-', 'linewidth', 1.5,'Marker','<',...
                                           'markerindices',(1:50:500),'MarkerSize',8)
axis tight
xlabel('Iteration');
ylabel('Best fitness obtained so far');
% title(['F', num2str(ii)])
title('Convergence curve');
legend('ZOA', 'ZOA1t', 'ZOA1r', 'ZOA2t', 'ZOA2r', 'ZOA3t', 'ZOA3r')
set(gca, 'FontSize', 18);


fprintf('Ave: %.4f  %.4f  %.4f  %.4f  %.4f  %.4f  %.4f \n', ...
    ave1, ave2, ave3, ave4, ave5, ave6, ave7);
fprintf('Std: %.4f  %.4f  %.4f  %.4f  %.4f  %.4f  %.4f \n', ...
    s1, s2, s3, s4, s5, s6, s7);
fprintf('Best: %.4f  %.4f  %.4f  %.4f  %.4f  %.4f  %.4f \n', ...
    min1, min2, min3, min4, min5, min6, min7);

