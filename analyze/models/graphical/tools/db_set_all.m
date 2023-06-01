function db_set_all(field,val)
%DB_SET_ALL Set the value of a field for all entries in the database
global REC_DB RECS;
for r=1:RECS
    REC_DB{r}=setfield(REC_DB{r},field,val);
end

