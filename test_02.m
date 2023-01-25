
clc

filename = 'temp_log.txt';

fileID = fopen('temp_log.txt', 'w');
line = ['t,s' '\t' 'A,K' '\t' 'B,K'];
fprintf(fileID, [line '\n']);

Fig = figure('position', [250 255 736 504]);

% Connect
COM_port_str = 'COM4';
Serial_obj = Connect(COM_port_str);
Timer = tic();

Time = 0;

Temp_log.time = [];
Temp_log.a = [];
Temp_log.b = [];
i = 0;
while Time < 10
Temp = Get_temp(Serial_obj);
% show_temp(Temp);

Time = toc(Timer);
Time_str = num2str(Time, '%09.1f');
T_A_str = num2str(Temp.A, '%06.2f');
T_B_str = num2str(Temp.B, '%06.2f');
line = [Time_str '\t' T_A_str '\t' T_B_str];
fprintf(fileID, [line '\n']);
disp([Time_str ' ' T_A_str ' ' T_B_str])

i = i + 1;
Temp_log.time(i) = Time;
Temp_log.a(i) = Temp.A;
Temp_log.b(i) = Temp.B;

subplot(2, 1, 1)
cla
plot(Temp_log.time/60, Temp_log.a);
xlabel('time, min')
ylabel('Temp, K')
drawnow

subplot(2, 1, 2)
cla
plot(Temp_log.time/60, Temp_log.b);
xlabel('time, min')
ylabel('Temp, K')
drawnow

pause(0.2);
end

delete(Serial_obj);
disp([newline '~~DISCONNECTED~~'])
fclose(fileID);







