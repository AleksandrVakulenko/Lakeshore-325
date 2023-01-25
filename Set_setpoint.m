function set_point_out = Set_setpoint(Serial_obj, Set_point_in)
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
Send_cmd(Serial_obj, CMD);
% disp(Data)

CMD = "SETP?";
Send_cmd(Serial_obj, CMD);
[Data, ~] = get_bytes(Serial_obj);
% disp(Data)
set_point_out = str2num(Data);
end