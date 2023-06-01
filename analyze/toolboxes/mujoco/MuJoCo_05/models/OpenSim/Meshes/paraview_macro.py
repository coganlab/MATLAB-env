try: paraview.simple
except: from paraview.simple import *

import os

os.chdir('C:\\opensim3\\geometry')
ls=os.listdir(os.getcwd())
for file in ls:
  suffix=file[-4:]
  if suffix=='.vtp':
    reader = XMLPolyDataReader( FileName=file )
    writer = PSTLWriter(Input=reader, FileName=[file[:-4]+'.stl'])
    writer.UpdatePipeline()
