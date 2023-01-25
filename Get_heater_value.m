function htr = Get_heater_value(Serial_obj) % '%'
% FIXME: check units (%)
% FIXME: use timeout_flag

CMD = "HTR?";
Send_cmd(Serial_obj, CMD);
[Data, timeout_flag] = get_bytes(Serial_obj);
htr = str2num(Data); % '%'

end
