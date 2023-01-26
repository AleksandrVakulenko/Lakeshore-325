
function Serial_obj = Connect(COM_port_str)

try
Serial_obj = serialport(COM_port_str, 9600, ...
                        'Parity', 'odd', ...
                        'DataBits', 7, ...
                        'StopBits', 1);
disp(['CONNECTED:' newline IND_query(Serial_obj) newline]);
catch msg
	error(['COM port connection error:' newline msg.message])
end

end