
close all
clc
mytemps()


function mytemps()

% settings
filename = 'temp_log.txt';
COM_port_str = 'COM4';

% % Log file open
% fileID = fopen('temp_log.txt', 'w');
% line = ['t,s' '\t' 'A,K' '\t' 'B,K'];
% fprintf(fileID, [line '\n']);

% % Device connect
% Temp_controller = Lakeshore325(COM_port_str);
Last_setpoint = 1; % FIXME: GET INIT Setpoint
% FIXME: GET INIT State of all values


% figure create
Fig = figure('position', [340 330 1040 660]);
Temp_field = uicontrol('Style', 'edit', 'string', num2str(Last_setpoint), 'Position', [10 45 75 25]);
Temp_field.Callback = @Value_changed;
Temp_set = uicontrol('Style', 'pushbutton', 'string', 'Set', 'Position', [10 10 75 25]);
Temp_set.Callback = @Set_temp_call;
Stop_button = uicontrol('Style', 'pushbutton', 'string', 'Stop', 'Position', [100 10 75 25]);
Stop_button.Callback = @stop;

Heater_button = uicontrol('Style', 'popupmenu', 'String', {'Off', '2.5 W', '25 W'}, 'Position', [200 45 75 25]);



i = 0;
stop_flag = 0;
while ~stop_flag
    
    
    
    drawnow
end
% FIXME: turn off heater
close();



% Callbacks
    function stop(src, event)
        stop_flag = 1;
        disp('Stop callback');
    end

    function Value_changed(src, event)
        Temp_str = get(Temp_field, 'string');
        Temp_value = str2num(Temp_str);
        if ~isempty(Temp_value)
            Last_setpoint = Temp_value;
        else
            set(Temp_field, 'string', num2str(Last_setpoint));
        end
    end

    function Set_temp_call(src, event)
        Temp_str = get(Temp_field, 'string');
        Temp_value = str2num(Temp_str);
        if ~isempty(Temp_value)
            disp(Temp_value);
            % FIXME: add real function with controller use
        else
            warning('Not a number');
        end
    end

end















