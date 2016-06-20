function type=identifity_acquisition_type(filename)

if ~isempty(findstr(filename,'Coupe selon X'))||...
        ~isempty(findstr(filename,'Coupe selon  X'))||...
        ~isempty(findstr(filename,'Scan selon X'))
    type='X';
elseif ~isempty(findstr(filename,'Coupe selon Y'))||...
        ~isempty(findstr(filename,'Coupe selon  Y'))||...
        ~isempty(findstr(filename,'Scan selon Y'))
    type='Y';
elseif ~isempty(findstr(filename,'3D rev fast axis'))
    type='ThreeD_rfa';
elseif ~isempty(findstr(filename,'3D HD'))
    type='HD';
elseif ~isempty(findstr(filename,'3D'))
    type='ThreeD';
elseif ~isempty(findstr(filename,'Coupe'))
    type='Slice';
else
    type='unknown';
end
end