
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
obj.set_setpoint(273.18); %K

% Get setpoint
set_point_out = obj.get_setpoint();
disp(['Set point: ' num2str(set_point_out)]);

% Set and Get Heater range
Range = 0;
obj.set_heater_range(Range);

% Get PID values
PID = obj.get_pid();
disp([newline 'PID:'])
disp(PID)

% Set and Get ramp status
rate = 2.0; % K/min
enable = false;
obj.set_ramp(enable, rate);

% Get ramp status
status = obj.get_ramp_status();
disp('Ramp status:')
disp(status)


%--------------------------------------------------------------------
delete(obj);
disp([newline '~~DISCONNECTED~~'])









