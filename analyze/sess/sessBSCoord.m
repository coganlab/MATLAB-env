function [x, y, z] = sessBSCoord(session)

%Returns Brainsight Coordinates for a given day and tower

eval([MONKEYDIR '/m/BS_Coordinates'])


for n = 1: length(BSCoord)
    if BSCoord{n,1} == Day && BSCoord{n,2} == Tower
        x = BSCoord(n,3)
        y = BSCoord(n,4)
        z = BSCoord(n,5)
    end
end

end
