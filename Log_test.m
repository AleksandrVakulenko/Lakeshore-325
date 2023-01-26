
clc

filename = 'temp_log.txt';
COM_port_str = 'COM4';

% Log file open
fileID = fopen('temp_log.txt', 'w');
Tab = '\t';
line = ['time_s' Tab ...
        'TempA_K' Tab 'TempB_K' Tab ...
        'Setpoint_K' Tab ...
        'Heater_%' Tab ...
        'Ramp', Tab 'Rate_K/m'];
fprintf(fileID, [line '\n']);

Fig = figure('position', [250 255 736 504]);


% Device connect
Temp_controller = Lakeshore325(COM_port_str);


% Timer start
Timer = tic();
Time = 0;

Temp_log = [];
% Temp_log.time = [];
% Temp_log.a = [];
% Temp_log.b = [];
i = 0;
while Time < 10
Time = toc(Timer);
Temp = Temp_controller.get_temp();
Set_point = Temp_controller.get_setpoint();
Heater_value = Temp_controller.get_heater_value();
Ramp_status = Temp_controller.get_ramp_status();

Time_str = num2str(Time, '%09.1f');
T_A_str = num2str(Temp.A, '%06.2f');
T_B_str = num2str(Temp.B, '%06.2f');
Set_point_str = num2str(Set_point, '%06.2f');
Heater_value_str = num2str(Heater_value, '%06.2f');
Ramp_en_srt = num2str(Ramp_status.enable, '%01.0f');
Rate_str = num2str(Ramp_status.rate, '%06.2f');
line = [Time_str '\t' ...
        T_A_str '\t' T_B_str '\t' ...
        Set_point_str '\t' ...
        Heater_value_str '\t' ...
        Ramp_en_srt '\t' Rate_str];
fprintf(fileID, [line '\n']);

disp([T_A_str ' ' Set_point_str ' ' ...
      Heater_value_str ' ' ...
      Ramp_en_srt ' ' Rate_str]);

i = i + 1;
Temp_log.time(i) = Time;
Temp_log.temp(i) = Temp;
Temp_log.sp(i) = Set_point;
Temp_log.heater(i) = Heater_value;
Temp_log.Ramp_status = Ramp_status;

subplot(2, 1, 1)
hold on
cla
plot(Temp_log.time/60, Temp_log.temp.a);
plot(Temp_log.time/60, Temp_log.sp);
xlabel('time, min')
ylabel('Temp, K')
drawnow

subplot(2, 1, 2)
cla
plot(Temp_log.time/60, Temp_log.temp.b);
xlabel('time, min')
ylabel('Temp, K')
drawnow

pause(0.2);
end


% Device disconnect and close file
delete(Temp_controller);
fclose(fileID);







