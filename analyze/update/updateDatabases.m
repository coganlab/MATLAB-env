function updateDatabases(SpikeSess,FieldSess,MultiunitSess)
%
%   updateDatabases(SpikeSess,FieldSess,MultiunitSess)
%
%   runs updateField_Database, updateSpike_Database,
%   updateSpikeField_Database, updateFieldField_Database
%   updateMultiunit_Database, updateMultiunitField_Database
%   
%   And if you want it, uncomment the following:
%   updateSpikeSpike_Database; updateMultiunitMultiunit_Database;
%   updateSpikeMultiunit_Database; 
%   updateSpikeFieldField_Database; updateMultiunitFieldField_Database;
%   updateSpikeSpikeField_Database; updateMultiunitMultiunitField_Database;
%   updateSpikeMultiunitField_Database; updateFieldFieldField_Database;

if nargin == 0
    updateField_Database;
    updateSpike_Database;
    updateSpikeField_Database;
    updateFieldField_Database;
    updateMultiunit_Database;
    updateMultiunitField_Database;
    
%     updateSpikeSpike_Database;
%     updateMultiunitMultiunit_Database;
%     updateSpikeMultiunit_Database;
%     updateSpikeFieldField_Database;
%     updateMultiunitFieldField_Database;
%     updateSpikeSpikeField_Database;
%     updateMultiunitMultiunitField_Database;
%     updateSpikeMultiunitField_Database;
%     updateFieldFieldField_Database;
else
    if nargin < 3; MultiunitSess = []; end
    if nargin < 2; FieldSess = []; end
        updateField_Database(FieldSess);
        updateSpike_Database(SpikeSess);
        addSpikeField_Database(SpikeSess,FieldSess);
        updateSpikeField_NumTrials(SpikeSess,FieldSess);
        updateSpikeField_Database;
        addFieldField_Database(FieldSess);
        updateFieldField_NumTrials(FieldSess);
        updateFieldField_Database;
        updateMultiunit_Database(MultiunitSess);
        addMultiunitField_Database(MultiunitSess,FieldSess);
        updateMultiunitField_NumTrials(MultiunitSess,FieldSess);
        updateMultiunitField_Database;
        
%         addSpikeSpike_Database(SpikeSess);
%         updateSpikeSpike_NumTrials(SpikeSess);
%         updateSpikeSpike_Database;
%         
%         addMultiunitMultiunit_Database(MultiunitSess);
%         updateMultiunitMultiunit_NumTrials(MultiunitSess);
%         updateMultiunitMultiunit_Database;
%         
%         addSpikeMultiunit_Database(SpikeSess,MultiunitSess);
%         updateSpikeMultiunit_NumTrials(SpikeSess,MultiunitSess);
%         updateSpikeMultiunit_Database;
%         
%         addSpikeFieldField_Database(SpikeSess,FieldSess);
%         updateSpikeFieldField_NumTrials(SpikeSess,FieldSess);
%         updateSpikeFieldField_Database;
%         
%         addMultiunitFieldField_Database(MultiunitSess,FieldSess);
%         updateMultiunitFieldField_NumTrials(MultiunitSess,FieldSess);
%         updateMultiunitFieldField_Database;
%         
%         addSpikeSpikeField_Database(SpikeSess,[],FieldSess);
%         updateSpikeSpikeField_NumTrials(SpikeSess,[],FieldSess);
%         updateSpikeSpikeField_Database;
%         
%         addMultiunitMultiunitField_Database(MultiunitSess,[],FieldSess);
%         updateMultiunitMultiunitField_NumTrials(MultiunitSess,FieldSess);
%         updateMultiunitMultiunitField_Database;
%         
%         addSpikeMultiunitField_Database(SpikeSess,MultiunitSess,FieldSess);
%         updateSpikeMultiunitField_NumTrials(SpikeSess,MultiunitSess,FieldSess);
%         updateSpikeMultiunitField_Database;
%         
%         addFieldFieldField_Database(FieldSess);        
%         updateFieldFieldField_NumTrials(FieldSess);
%         updateFieldFieldField_Database;
end




