function [normed] = nor_me(data)

normed = (data - min(data)) / (max(data) - min(data));

end