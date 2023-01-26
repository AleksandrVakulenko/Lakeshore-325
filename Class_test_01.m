



clc

COM_port_str = 'COM4';

obj = Lakeshore325(COM_port_str);

%--------------------------------------------------------------------

% Get temp
Temp = obj.get_temp();
show_temp(Temp);

% Get heater value
htr = obj.get_heater_value();
disp(['Heater: ' num2str(htr, '%06.2f'), '%']);

% Set and Get setpoint
set_point_out = obj.set_setpoint(273.18); %K
disp(['Set point: ' num2str(set_point_out)]);

% Get setpoint
set_point_out = obj.get_setpoint();
disp(['Set point: ' num2str(set_point_out)]);

% Set and Get Heater range
Range = 0;
out_range = obj.set_heater_range(Range);
disp(['Heater range = ' num2str(out_range)])

% Get PID values
PID = obj.get_pid();
disp(PID)

% Set and Get ramp status
% rate = 2.1; % K/min
% enable = false;
% status = Set_ramp(Serial_obj, enable, rate);
% disp(status)

% Get ramp status
status = obj.get_ramp_status();
disp(status)



%--------------------------------------------------------------------

delete(obj);
disp([newline '~~DISCONNECTED~~'])









