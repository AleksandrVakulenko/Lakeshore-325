
clc

filename = 'temp_log_001.txt';
COM_port_str = 'COM4';

% Log file open
% FIXME: add Heater status
fileID = fopen(filename, 'w');
Tab = '\t';
line = ['time_s' Tab ...
        'TempA_K' Tab 'TempB_K' Tab ...
        'Setpoint_K' Tab ...
        'Heater_1' Tab ...
        'Ramp', Tab 'Rate_K/m'];
fprintf(fileID, [line '\n']);

Fig = figure('position', [250 255 736 504]);
global stop_flag;
Stop_button = uicontrol('Style', 'pushbutton', 'string', 'Stop', ...
    'Position', [10 10 75 25]);
Stop_button.Callback = @stop;


% Device connect
Temp_controller = Lakeshore325(COM_port_str);

% ---temp---------------------------------------------------------------
Test_n = 4;
Test_string = 'Free heating';
% ----------------------------------------------------------------------

% Temp = Temp_controller.get_temp();
% Temp_controller.set_setpoint(Temp.a);
Temp_controller.set_ramp(false, 2);
Temp_controller.set_heater_range(0);
Temp_controller.set_setpoint(5);


% ----------------------------------------------------------------------

% Timer start
Timer = tic();
Time = 0;
Temp_log = [];
i = 0;
stop_flag = 0;
while ~stop_flag
Time = toc(Timer);
Temp = Temp_controller.get_temp();
Set_point = Temp_controller.get_setpoint();
Heater_value = Temp_controller.get_heater_value();
Ramp_status = Temp_controller.get_ramp_status();

Time_str = num2str(Time, '%09.1f');
T_A_str = num2str(Temp.a, '%06.2f');
T_B_str = num2str(Temp.b, '%06.2f');
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

disp([Set_point_str ' ' T_A_str ' ' T_B_str ' ' ...
      Heater_value_str ' ' ...
      Ramp_en_srt ' ' Rate_str]);

i = i + 1;
Temp_log.time(i) = Time;
Temp_log.temp_a(i) = Temp.a;
Temp_log.temp_b(i) = Temp.b;
Temp_log.sp(i) = Set_point;
Temp_log.heater(i) = Heater_value;
Temp_log.ramp_enable(i) = Ramp_status.enable;
Temp_log.ramp_rate(i) = Ramp_status.rate;

subplot(2, 1, 1)
hold on
cla
plot(Temp_log.time/60, Temp_log.temp_a);
plot(Temp_log.time/60, Temp_log.sp);
xlabel('time, min')
ylabel('Temp, K')
drawnow

subplot(2, 1, 2)
cla
plot(Temp_log.time/60, Temp_log.temp_b);
xlabel('time, min')
ylabel('Temp, K')
drawnow

% pause(1);
end


% Device disconnect and close file
% Temp_controller.set_heater_range(0);
Temp_controller.set_ramp(false, 2);
delete(Temp_controller);
fclose(fileID);
fclose('all'); % FIXME: why?

% ------ temp ------
Mat_name = [num2str(Test_n, '%03u') '.mat'];
save(Mat_name, 'Temp_log', 'Test_string');
% ------------------

function stop(src, event)
global stop_flag;
stop_flag = 1;
end




