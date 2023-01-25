function status = Get_ramp_status(Serial_obj)

CMD = "RAMP?";
Send_cmd(Serial_obj, CMD);
[Data, timeout_flag] = get_bytes(Serial_obj);
Data = sscanf(Data, '%f,%f');

status.enable = Data(1); % t/f
status.rate = Data(2); % K/min

end