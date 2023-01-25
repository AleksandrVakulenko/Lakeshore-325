

function PID = Get_pid(Serial_obj)

CMD = "PID?";
Send_cmd(Serial_obj, CMD);
[Data, timeout_flag] = get_bytes(Serial_obj);
Data = sscanf(Data, '%f,%f,%f');
PID.p = Data(1);
PID.i = Data(2);
PID.d = Data(3);

end


