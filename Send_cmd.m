



function Send_cmd(Serial_obj, CMD)

Term = [char(13) char(10)];
CMD_out = [char(CMD) Term];
write(Serial_obj, CMD_out, "uint8");
pause(0.07); % FIXME: magic constant

end






