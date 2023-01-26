function set_point_out = Get_setpoint(Serial_obj)
CMD = "SETP?";
Send_cmd(Serial_obj, CMD);
[Data, ~] = get_bytes(Serial_obj);
% disp(Data)
set_point_out = str2num(Data);
end