function fmt = scanformat(filename, delimiter, numheaders)
fid = fopen(filename, 'rb');
for n = 1:numheaders+1
    line = fgetl(fid);
end

isStrCol = isnan( str2double( regexp( line, ['[^' delimiter ']+'], 'match' )));
fmt = cell( 1, numel(isStrCol) ) ;
fmt(isStrCol)  = {'%s'} ;
fmt(~isStrCol) = {'%f'} ;
fmt = [fmt{:}] ;

fclose(fid);
end