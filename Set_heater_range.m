function out_range = Set_heater_range(Serial_obj, Range) % 0, 1(2.5W), 2(25W)
% FIXME: setpoint only for LOOP 1 now

if ~(Range ~= 0 || Range ~= 1 || Range ~= 2)
    Range = 0;
    warning('Wrong heater range. Heater Disabled.');
end

CMD = ['RANGE 1, ' num2str(Range)];
Send_cmd(Serial_obj, CMD);

CMD = 'RANGE? 1';
Send_cmd(Serial_obj, CMD);
[out_range, ~] = get_bytes(Serial_obj);

end