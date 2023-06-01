function UpdateStateBuffer(State)
%
%   Buffer.State_Pos marks where next state should be written
%
global Buffer
%Buffer.State
disp('Updating State Buffer');
Over = size(State,2) - (size(Buffer.State,2)-Buffer.State_Pos+1);
if Over > 0
    Rem =  size(Buffer.State,2)-Buffer.State_Pos+1;
    Buffer.State(1:3,Buffer.State_Pos:end) = State(:,1:Rem);
    Buffer.State(1:3,1:Over) = State(:,Rem+1:end);
    Buffer.State_Pos = Over+1;
elseif Over == 0
    Buffer.State(1:3,Buffer.State_Pos:end) = State;
    Buffer.State_Pos = 1;
elseif Over < 0
    Buffer.State(1:3,Buffer.State_Pos:Buffer.State_Pos+size(State,2)-1) = State;
    Buffer.State_Pos = Buffer.State_Pos+size(State,2);
end

%Buffer.State