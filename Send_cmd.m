



function Send_cmd(CMD)

Term = [char(13) char(10)];
CMD_out = [char(CMD) Term];
write(Serial_obj, CMD_out, "uint8");
pause(0.05);

end






