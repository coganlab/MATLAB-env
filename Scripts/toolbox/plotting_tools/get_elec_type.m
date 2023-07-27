function types = get_elec_type(subj)
data = get_RAS_data(subj);
types = unique(data.type);
types = strjoin(types, '');