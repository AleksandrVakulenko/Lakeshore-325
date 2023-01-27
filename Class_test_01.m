
clc

COM_port_str = 'COM4';
Temp_controller = Lakeshore325(COM_port_str);

%--------------------------------------------------------------------

% Get temp
Temp = Temp_controller.get_temp();
disp(['A: ' num2str(Temp.a, '%+07.2f'), ' K | B: ', num2str(Temp.b, '%+07.2f') ' K'])

% Get heater value
htr = Temp_controller.get_heater_value();
disp(['Heater: ' num2str(htr, '%06.2f'), '%']);

% Set and Get setpoint
Temp_controller.set_setpoint(273.18); %K

% Get setpoint
set_point_out = Temp_controller.get_setpoint();
disp(['Set point: ' num2str(set_point_out)]);

% Set and Get Heater range
Range = 0;
Temp_controller.set_heater_range(Range);

% Get PID values
PID = Temp_controller.get_pid();
disp([newline 'PID:'])
disp(PID)

% Set and Get ramp status
rate = 2.0; % K/min
enable = false;
Temp_controller.set_ramp(enable, rate);

% Get ramp status
status = Temp_controller.get_ramp_status();
disp('Ramp status:')
disp(status)


%--------------------------------------------------------------------
delete(Temp_controller);
disp([newline '~~DISCONNECTED~~'])









