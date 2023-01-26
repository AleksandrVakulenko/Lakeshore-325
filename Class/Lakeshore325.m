

% TODO:
%  1) ADD SET RAMP !!!
%  2) Class testing
%  3) Power regulator
%  4) One function to Get status
%  5)

% dofixrpt('Lakeshore325.m','file') -> find notes in file
% dofixrpt(dir) -> find notes in all files in directory 'dir'

classdef Lakeshore325 < handle
    %--------------------------------PUBLIC--------------------------------
    methods (Access = public)
        function obj = Lakeshore325(port_name)
            obj.COM_port_str = char(port_name);
            close_all_objects();
            port_name_check(obj.COM_port_str);
            obj.Serial_obj = Connect(obj.COM_port_str);
            disp(['Lakeshore325 connected at port: ' obj.COM_port_str newline]);
        end
        
        
        function delete(obj)
            % FIXME: Stop heating?
            delete(obj.Serial_obj);
            disp(['Disconnecting at port: ' obj.COM_port_str])
        end

        
        %-------------------------------GETTER--------------------------------
        function htr = get_heater_value(obj) % '%'
            % FIXME: check units (%)
            Send_cmd(obj.Serial_obj, "HTR?");
            [Data, timeout_flag] = get_bytes(obj.Serial_obj);
            if timeout_flag
                warning('timeout_flag in Get_heater_value');
                htr = NaN; % '%'
            else
                htr = str2num(Data); % '%'
            end
            
        end
        
        
        function PID = get_pid(obj)
            Send_cmd(obj.Serial_obj, "PID?");
            [Data, timeout_flag] = get_bytes(obj.Serial_obj);
            if timeout_flag
                warning('timeout_flag in Get_pid');
                Data = [NaN, NaN, NaN];
            else
                Data = sscanf(Data, '%f,%f,%f');
            end
            PID.p = Data(1);
            PID.i = Data(2);
            PID.d = Data(3);
        end
        
        
        function status = get_ramp_status(obj)
            Send_cmd(obj.Serial_obj, "RAMP?");
            [Data, timeout_flag] = get_bytes(obj.Serial_obj);
            if timeout_flag
                warning('timeout_flag in Get_ramp_status');
                Data = [NaN, NaN];
            else
                Data = sscanf(Data, '%f,%f');
            end
            status.enable = Data(1); % t/f
            status.rate = Data(2); % K/min
        end
        
        
        function set_point_out = get_setpoint(obj)
            Send_cmd(obj.Serial_obj, "SETP?");
            [Data, timeout_flag] = get_bytes(obj.Serial_obj);
            if timeout_flag
                warning('timeout_flag in Get_setpoint');
                set_point_out = NaN;
            else
                set_point_out = str2num(Data);
            end
        end
        
        
        function Temp = get_temp(obj) %K, K
            Send_cmd(obj.Serial_obj, "KRDG? A");
            [Data, timeout_flag] = get_bytes(obj.Serial_obj);
            if timeout_flag
                warning('timeout_flag in Get_temp (A)');
                Temp.A = NaN; %K
            else
                Temp.A = str2num(Data); %K
            end
            Send_cmd(obj.Serial_obj, "KRDG? B");
            [Data, timeout_flag] = get_bytes(obj.Serial_obj);
            if timeout_flag
                warning('timeout_flag in Get_temp (B)');
                Temp.B = NaN; %K
            else
                Temp.B = str2num(Data); %K
            end
        end
        
        
        
        %-------------------------------SETTER--------------------------------
        function set_heater_range(obj, Range)
            % 0 - OFF, 1 - 2.5W, 2 - 25W
            if ~(Range ~= 0 || Range ~= 1 || Range ~= 2)
                Range = 0;
                warning('Wrong heater range. Heater Disabled.');
            end
            % FIXME: setpoint only for LOOP 1 now
            CMD = ['RANGE 1, ' num2str(Range)];
            Send_cmd(obj.Serial_obj, CMD);
        end
        
        
        function set_setpoint(obj, Set_point_in)
            Low_limit = 5; %K FIXME: magic constants
            High_limit = 300; %K
            if Set_point_in < Low_limit
                Set_point_in = Low_limit;
                warning(['Setpoint limited by ' num2str(Low_limit)]);
            end
            if Set_point_in > High_limit
                Set_point_in = High_limit;
                warning(['Setpoint limited by ' num2str(High_limit)]);
            end
            % FIXME: setpoint only for LOOP 1 now
            CMD = ['SETP 1,' num2str(Set_point_in, '%6.2f')];
            Send_cmd(obj.Serial_obj, CMD);
        end
        
        
        function set_ramp(obj, enable, rate)
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
            Send_cmd(obj.Serial_obj, CMD);
        end
    end
    
    %-------------------------------PRIVATE--------------------------------
    properties (Access = private)
        COM_port_str = '';
        Serial_obj = [];
    end
    
    methods (Access = private)
        function Send_cmd(Serial_obj, CMD)
            Term = [char(13) char(10)];
            CMD_out = [char(CMD) Term];
            write(Serial_obj, CMD_out, "uint8");
            pause(0.07); % FIXME: magic constant
        end
        
    end
end


function Serial_obj = Connect(COM_port_str)
try
    Serial_obj = serialport(COM_port_str, 9600, ...
        'Parity', 'odd', ...
        'DataBits', 7, ...
        'StopBits', 1);
    Send_cmd(Serial_obj, "*IDN?");
    [IND_query, ~] = get_bytes(Serial_obj);
    disp(['CONNECTED:' newline IND_query]);
catch msg
    error(['COM port connection error:' newline msg.message])
end
end


function [Data_stream, timeout_flag] = get_bytes(Serial_obj)
Wait_timeout = 1; %s
timeout_flag = 0;
stop = 0;
Time_start = tic;
Data_stream = [];
while ~stop
    Bytes_count = Serial_obj.NumBytesAvailable;
    
    if Bytes_count > 0
        Data = read(Serial_obj, Bytes_count, "uint8");
        Data_stream = [Data_stream Data];
        
        if numel(Data_stream) >= 2
            term_flag = sum(Data_stream(end-1:end) == [13 10]);
            if term_flag == 2
                stop = 1;
            end
        end
    end
    
    Time_now = toc(Time_start);
    if Time_now > Wait_timeout && ~stop
        stop = 1;
        timeout_flag = 1;
        Data_stream = 0;
    end
    Data_stream = char(Data_stream);
    if numel(Data_stream) > 2
        Data_stream = Data_stream(1:end-2);
    end
end
end


function port_name_check(port_name)
Avilable_ports = serialportlist('available');
if ~(sum(Avilable_ports == port_name) == 1)
    Text_ports_list = '';
    for i = 1:numel(Avilable_ports)
        Text_ports_list = [Text_ports_list char(Avilable_ports(i)) newline];
    end
    
    msg = ['ERROR: No such com port name.' newline ...
        'List of avilable ports:' newline ...
        Text_ports_list ...
        'Provided name: ' port_name];
    error(msg)
end
end


function close_all_objects()
input_class_name = 'Lakeshore325';
baseVariables = evalin('base' , 'whos');
Indexes = string({baseVariables.class}) == input_class_name;
Var_names = string({baseVariables.name});
Var_names = Var_names(Indexes);
Valid = zeros(size(Var_names));
for i = 1:numel(Var_names)
    Valid(i) = evalin('base', ['isvalid(' char(Var_names(i)) ')']);
end
Valid = logical(Valid);
Var_names = Var_names(Valid);
for i = 1:numel(Var_names)
    evalin('base', ['delete(' char(Var_names(i)) ')']);
end
end










