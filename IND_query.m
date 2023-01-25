

function ans = IND_query(Serial_obj)
% FIXME: use timeout flag

CMD = "*IDN?";
Send_cmd(Serial_obj, CMD);
[ans, timeout_flag] = get_bytes(Serial_obj);


end

