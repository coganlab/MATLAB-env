function SessionType = getSessionType(Session)
%
%  SessionType = getSessionType(Session)
%

if length(Session)>7
  SessionType = Session{8};
  if iscell(SessionType)
    SessionTypeString = '';
    for iComp = 1:length(SessionType)
      SessionTypeString = [SessionTypeString SessionType{iComp}];
    end
    SessionType = SessionTypeString;
  end
else
Field5 = Session{5};
if length(Field5) == 1
    if iscell(Field5)
        if(length(Field5{1}) == 3)
            SessionType = 'Multiunit';
        elseif Field5{1}(1) > 14 || Field5{1}(1) < 1
            SessionType = 'Field';
        elseif Field5{1}(1) > 1
            SessionType = 'Spike';
        else
            SessionType = 'Multiunit';
        end
    else
        if Field5(1) > 14 || Field5(1) < 1
            SessionType = 'Field';
        elseif Field5(1) > 1
            SessionType = 'Spike';
        else
            SessionType = 'Multiunit';
        end
    end
else
    SessionType = [];
    for iSess = 1:length(Field5)
        if iscell(Field5{iSess})
            if(length(Field5{iSess}{1}) == 3)
                SessionType = [SessionType 'Multiunit'];
            elseif Field5{iSess}(1) > 14 || Field5{iSess}(1) < 1
                SessionType = [SessionType 'Field'];
            elseif Field5{iSess}(1) > 1
                SessionType = [SessionType 'Spike'];
            else
                SessionType = [SessionType 'Multiunit'];
            end
        else
            if(length(Field5{iSess}) == 3)
                SessionType = [SessionType 'Multiunit'];
            elseif Field5{iSess}(1) > 14 || Field5{iSess}(1) < 1
                SessionType = [SessionType 'Field'];
            elseif Field5{iSess}(1) < 14 && Field5{iSess}(1) > 1
                SessionType = [SessionType 'Spike'];
            else
                SessionType = [SessionType 'Multiunit'];
            end
        end
    end
end

% elseif length(Field5) == 2
%     if(iscell(Field5{1}))
%         if length(Field5{1}{1}) == 3 && (Field5{2}(1) > 14 || Field5{2}(1) < 1)
%             SessionType = 'MultiunitField';
%         elseif length(Field5{1}{1}) == 3 && length(Field5{2}{1}) == 3
%             SessionType = 'MultiunitMultiunit';
%         end
%     else
%         SessionType = [];
%         for iSess = 1:length(Field5)
%             if (Field5{iSess}(1) > 14 || Field5{iSess}(1) < 0)
%                 SessionType = [SessionType 'Field'];
%             elseif Field5{iSess}(1) < 14 && Field5{iSess}(1) > 1
%                 SessionType = [SessionType 'Spike'];
%             elseif Field5{iSess}(1) == 1
%                 SessionType = [SessionType 'Multiunit'];
%             end
%         end
%     end
% elseif length(Field5) == 3
%     if(iscell(Field5{1}))
%         %I'm not sure where this check come from, so I'm not sure how to
%         %update it. I will as it comes up.        
% %         if length(Field5{1}{1}) == 3 && (Field5{2}(1) > 14 || Field5{2}(1) < 1)
% %             SessionType = 'MultiunitField';
% %         elseif length(Field5{1}{1}) == 3 && length(Field5{2}{1}) == 3
% %             SessionType = 'MultiunitMultiunit';
% %         end 
%     else
%         SessionType = [];
%         for iSess = 1:length(Field5)
%             if (Field5{iSess}(1) > 14 || Field5{iSess}(1) < 0)
%                 SessionType = [SessionType 'Field'];
%             elseif Field5{iSess}(1) < 14 && Field5{iSess}(1) > 1
%                 SessionType = [SessionType 'Spike'];
%             elseif Field5{iSess}(1) == 1
%                 SessionType = [SessionType 'Multiunit'];
%             end
%         end  
%     end
% end

end
