function db_add(day,rec,chs)
%DB_ADD Add an entry to database

global REC_DB RECS;

idx = RECS+1;

    for ch=chs
	trial.day = day;
	trial.rec = rec;
	trial.ch = ch;
	REC_DB{idx} = trial;
	idx = idx + 1;
    end
RECS = idx - 1;

