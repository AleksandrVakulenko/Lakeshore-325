



function [Temp] = Get_temp(Serial_obj) %K, K

% FIXME: use timeout_flag

CMD = "KRDG? A";
Send_cmd(Serial_obj, CMD);
[Data, timeout_flag] = get_bytes(Serial_obj);
Temp.A = str2num(Data); %K

CMD = "KRDG? B";
Send_cmd(Serial_obj, CMD);
[Data, timeout_flag] = get_bytes(Serial_obj);
Temp.B = str2num(Data); %K


end





