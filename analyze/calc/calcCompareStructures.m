function [same] = calcCompareStructures(Struct1,Struct2)

%  calcCompareStructures(STRUCT1, STRUCT2)
%
%  Performs a recursive comparison of the contents of two
%  struct or cell arrays. 

same = 1;

if length(Struct1)==length(Struct2)
    for s=1:length(Struct1)
        if isstruct(Struct1) && isstruct(Struct2)
            S1 = Struct1(s);
            S2 = Struct2(s);
        elseif iscell(Struct1) && iscell(Struct2)
            S1 = Struct1{s};
            S2 = Struct2{s};
        elseif (isnan(Struct1)+isnan(Struct2))==2
            S1 = [];
            S2 = [];
        else
            same = 0; return;
        end
        f1 = [];
        f2 = [];
        try
            f1 = fieldnames(S1);
            f2 = fieldnames(S2);
            
            if ~isempty(f1) && ~isempty(f2)
                if length(f1)==length(f2)
                    
                    for f=1:length(f1)
                        if isequal(char(f1(f)),char(f2(f)))
                            data1 = getfield(S1,char(f1(f)));
                            data2 = getfield(S2,char(f2(f)));
                            if prod(single(size(data1)==size(data2)))
                                if isnumeric(data1) && isnumeric(data2)
                                    if isnan(data1) | isnan(data2)
                                        if (isnan(data1)+isnan(data2))~=2
                                            same = 0; return;
                                        end
                                    elseif ~prod(single(data1(1:prod(size(data1)))==data2(1:prod(size(data2)))))
                                        same = 0; return;
                                    end
                                elseif ischar(data1) && ischar(data2)
                                    if ~isequal(data1,data2)
                                        same = 0; return;
                                    end
                                elseif (isstruct(data1) && isstruct(data2)) || ...
                                        (iscell(data1) && iscell(data2))
                                    same = calcCompareStructures(data1,data2);
                                    if ~same return; end;
                                else
                                    same = 0; return;
                                end
                            else
                                same = 0; return;
                            end
                        else
                            same = 0; return;
                        end
                    end
                    
                else
                    same = 0; return;
                end
            end
            
        catch
            % This is a structure with no fields
            if isempty(S1) && isempty(S2)
                return;
            else
                if isnumeric(S1) && isnumeric(S2)
                  if numel(S1)==numel(S2)
                    diffProd = sum(single(S1(1:prod(size(S1)))~=S2(1:prod(size(S2)))));
                    nanTotal = sum(isnan(S2(isnan(S1))));
                    if sum(isnan(S1(isnan(S2))))~=nanTotal || diffProd>nanTotal
                      same = 0; return;
                    end
                  else
                    same = 0; return;                  
                  end              
                elseif ischar(S1) && ischar(S2)
                    if ~isequal(S1,S2)
                        same = 0; return;
                    end
                elseif (isstruct(S1) && isstruct(S2)) || ...
                        (iscell(S1) && iscell(S2))
                    same = calcCompareStructures(S1,S2);
                    if ~same return; end;
                else
                    same = 0; return;
                end
            end
        end
    end
else
    same = 0; return;
end