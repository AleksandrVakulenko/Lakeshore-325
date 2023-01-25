
% TODO:
%  1) File log
%  2) Make class
%  3) 


clc

COM_port_str = 'COM4';

% Connect
Serial_obj = Connect(COM_port_str);

% Get temp
Temp = Get_temp(Serial_obj);
show_temp(Temp);

% Get heater value
htr = Get_heater_value(Serial_obj);
disp(['Heater: ' num2str(htr, '%06.2f'), '%'])

% Set and Get setpoint
set_point_out = Set_setpoint(Serial_obj, 273.18);
disp(['Set point: ' num2str(set_point_out)]);

% Get setpoint
set_point_out = Get_setpoint(Serial_obj);
disp(['Set point: ' num2str(set_point_out)]);

% Set and Get Heater range
Range = 0;
out_range = Set_heater_range(Serial_obj, Range);
disp(['Heater range = ' num2str(out_range)])

% Get PID values
PID = Get_pid(Serial_obj);
disp(PID)

% Set and Get ramp status
rate = 2.1; % K/min
enable = false;
status = Set_ramp(Serial_obj, enable, rate);
disp(status)

% Get ramp status
status = Get_ramp_status(Serial_obj);
disp(status)


% CMD = "SETP?";
% Send_cmd(Serial_obj, CMD);
% [Data, ~] = get_bytes(Serial_obj);
% % disp(Data)
% set_point_out = str2num(Data);

delete(Serial_obj);
disp([newline '~~DISCONNECTED~~'])


function status = Set_ramp(Serial_obj, enable, rate)
% FIXME: only for loop 1
High_limit = 100;
Low_limit = 0;
if rate > High_limit
    rate = High_limit;
    warning(['Rate value limited by ' num2str(High_limit)]);
end
if rate < Low_limit
    rate = Low_limit;
    warning(['Rate value limited by ' num2str(Low_limit)]);
end

enable = logical(enable);

CMD = ['RAMP 1, ' num2str(enable), ', ', num2str(rate)];
Send_cmd(Serial_obj, CMD);

status = Get_ramp_status(Serial_obj);
end










