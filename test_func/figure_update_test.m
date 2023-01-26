



% figure




% c = uicontrol(Name,Value)




figure;
h = plot(rand(1,10));

gcf

for i = 1:1000
    
    
   updatePlot(h) 

%    pause(0.5)
end




function updatePlot(h)
    set(h,'ydata',rand(1,10));
    drawnow
end




