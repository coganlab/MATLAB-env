function replaceMultiunitSessInfo(SessNum)
%
%   replaceMultiunitSessInfo(SessNum)
%


global MONKEYDIR
disp(['Replacing Multiunit Session Info for SessNum = ' num2str(SessNum)]);
Multiunit_Session = loadMultiunit_Database;
load([MONKEYDIR '/mat/Multiunit_Session.mat'])
Session{SessNum}(1:6) = Multiunit_Session{SessNum}(1:6);
save([MONKEYDIR '/mat/Multiunit_Session.mat'],'Session')