function replaceFieldSessInfo(SessNum);
%
%   replaceFieldSessInfo(SessNum)
%



global MONKEYDIR
Field_Session = Field_Database;
disp(['Replacing Field Session Info for SessNum = ' num2str(SessNum)]);
load([MONKEYDIR '/mat/Field_Session.mat'])
Session{SessNum}(1:6) = Field_Session{SessNum};
save([MONKEYDIR '/mat/Field_Session.mat'],'Session')
