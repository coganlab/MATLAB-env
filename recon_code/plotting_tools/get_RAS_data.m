function data = get_RAS_data(subj)
fpath = get_RAS_path(subj);
data = parse_RAS_file(fpath);