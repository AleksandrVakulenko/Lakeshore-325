

function [Data_stream, timeout_flag] = get_bytes(Serial_obj)
Wait_timeout = 1; %s
timeout_flag = 0;
stop = 0;
Time_start = tic;
Data_stream = [];
while ~stop
    Bytes_count = Serial_obj.NumBytesAvailable;
    
    if Bytes_count > 0
        Data = read(Serial_obj, Bytes_count, "uint8");
        Data_stream = [Data_stream Data];
        
        if numel(Data_stream) >= 2
            term_flag = sum(Data_stream(end-1:end) == [13 10]);
            if term_flag == 2
                stop = 1; 
            end
        end
    end
    
    Time_now = toc(Time_start);
    if Time_now > Wait_timeout && ~stop
        stop = 1;
        timeout_flag = 1;
        Data_stream = 0;
    end
    Data_stream = char(Data_stream);
    if numel(Data_stream) > 2
        Data_stream = Data_stream(1:end-2);
    end
end
end

