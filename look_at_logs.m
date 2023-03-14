
close all

load('Logs/001.mat')
figure
plot(Temp_log.time/60, Temp_log.temp_a)
title(Test_string)

load('Logs/002.mat')
figure
plot(Temp_log.time/60, Temp_log.temp_a)
title(Test_string)

load('Logs/003.mat')
figure
plot(Temp_log.time/60, Temp_log.temp_a)
title(Test_string)

load('Logs/004.mat')
figure
plot(Temp_log.time/60, Temp_log.temp_a)
title(Test_string)

%%

load('Logs/Cool_test_log.mat')

time_1 = Temp_log.time/60; %m
Temp_1 = Temp_log.temp_a; %K


load('Logs/003.mat')

time_2 = Temp_log.time/60; %m
Temp_2 = Temp_log.temp_a; %K

hold on
plot(time_1, Temp_1)
plot(time_2+104.3, Temp_2)

xlim([103 120])



%%

% load('Logs/Cool_test_log.mat')
% 
% plot(Temp_log.time/60, Temp_log.temp_a)
% hold on

% load('Logs/004.mat')
load('Logs/Cool_test_log.mat')

time = Temp_log.time/60; %m
Temp = Temp_log.temp_a; %K

Temp2 = movmean(Temp, 500);


figure
hold on
plot(time, Temp)
plot(time, Temp2)

rate_time = time(1:end-1);
rate = diff(Temp2)./diff(time);
rate = movmean(rate, 50);

figure
plot(rate_time, rate, 'linewidth', 2)
ylabel('rate, K/m')
xlabel('time, m')
title('Cooling')






