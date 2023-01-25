

COM_port_str = 'COM1';

try
Serial_obj = serialport('Port', COM_port_str, ...
                        'BaudRate', 9600, ...
                        'Parity', 'odd', ...
                        'DataBits', 7, ...
                        'StopBits', 1, ...
                        'Terminator', "CR/LF");
disp('connected')
catch msg
	error(['COM port connection error:' newline msg.message])
end
                    

CMD = "*IDN?";

write(obj.Serial_obj, CMD);
pause(0.05);

pause(0.5);
[Data, timeout_flag] = get_bytes(Serial_obj);

disp('Data:');
disp(Data);


delete(Serial_obj);



function [Data, timeout_flag] = get_bytes(Serial_obj)
Wait_timeout = 1;
timeout_flag = 0;
stop = 0;
Time_start = tic;
while ~stop
    Bytes_count = Serial_obj.NumBytesAvailable;
    
    if Bytes_count > 0
        Data = read(Serial_obj, Bytes_count, "uint8");
        stop = 1;
    end
    
    Time_now = toc(Time_start);
    if Time_now > Wait_timeout
        stop = 1;
        timeout_flag = 1;
        Data = 0;
    end
end
end










