#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 15:19:11 2020

@author: alexshields
"""

import mne
import numpy as np
import matplotlib
%matplotlib qt


def make_montage(montage_fname)
    #load custom montage file
    montage = mne.channels.read_custom_montage("124_Ch_Test.bvef")
    return montage

def load_data(vhdr_fname):
    #Load in EEG file
    raw = mne.io.read_raw_brainvision(vhdr_fname, preload=True)

    #Channel renaming dictionary for TwoBeeps patients E2 - 27
    #1-32:97:128, 33-64:65-96, 65-96:33-64. 97-128:1-32
    name_dict = {'1':'97','2':'98','3':'99','4':'100','5':'101','6':'102',
             '7':'103','8':'104','9':'105','10':'106','11':'107','12':'108',
             '13':'109','14':'110','15':'111','16':'112','17':'113',
             '18':'114','19':'115','20':'116','21':'117','22':'118',
             '23':'119','24':'120','25':'121','26':'122','27':'123',
             '28':'124','29':'125','30':'126','31':'127','32':'128','33':'65',
             '34':'66','35':'67','36':'68','37':'69','38':'70','39':'71',
             '40':'72','41':'73','42':'74','43':'75','44':'76','45':'77',
             '46':'78','47':'79','48':'80','49':'81','50':'82','51':'83',
             '52':'84','53':'85','54':'86','55':'87','56':'88','57':'89',
             '58':'90','59':'91','60':'92','61':'93','62':'94','63':'95',
             '64':'96','65':'33','66':'34','67':'35','68':'36','69':'37',
             '70':'38','71':'39','72':'40','73':'41','74':'42','75':'43',
             '76':'44','77':'45','78':'46','79':'47','80':'48','81':'49',
             '82':'50','83':'51','84':'52','85':'53','86':'54','87':'55',
             '88':'56','89':'57','90':'58','91':'59','92':'60','93':'61',
             '94':'62','95':'63','96':'64','97':'1','98':'2','99':'3',
             '100':'4','101':'5','102':'6','103':'7','104':'8','105':'9',
             '106':'10','107':'11','108':'12','109':'13','110':'14',
             '111':'15','112':'16','113':'17','114':'18','115':'19',
             '116':'20','117':'21','118':'22','119':'23','120':'24',
             '121':'25','122':'26','123':'27','124':'28','125':'29',
             '126':'30','127':'31','128':'32'}
    
    #list to reorder channels after renaming
    order_list = ['1','2','3','4','5','6','7','8','9','10','11','12','13',
                  '14','15','16','17','18','19','20','21','22','23','24','25',
                  '26','27','28','29','30','31','32','33','34','35','36','37',
                  '38','39','40','41','42','43','44','45','46','47','48','49',
                  '50','51','52','53','54','55','56','57','58','59','60','61',
                  '62','63','64','65','66','67','68','69','70','71','72','73',
                  '74','75','76','77','78','79','80','81','82','83','84','85',
                  '86','87','88','89','90','91','92','93','94','95','96','97',
                  '98','99','100','101','102','103','104','105','106','107',
                  '108','109','110','111','112','113','114','115','116','117',
                  '118','119','120','121','122','123','124','125','126','127',
                  '128']

    #rename channels based on above dictionary
    raw.rename_channels(name_dict)
    
    #reorder channels to go sequentially from 1 to 128
    raw.reorder_channels(order_list)
    

    #set eog channels
    raw.set_channel_types({'125':'eog','126':'eog','127':'eog','128':'eog'})
    
    #apply bandpass filter, set frequency bands
    raw.filter(0.5,40)
    
    #after filtering, remove bad channels in qt plot
    raw.plot()
    
def set_data(data, custom_montage)
    #set reference to average
    raw.set_eeg_reference('average')
    
    #plot data again to remove any remaining bad channels
    raw.plot()
    
    #set raw data to custom montage 
    raw.set_montage(montage)
    
def erp(data, custom_montage):  
    #get events and their IDs from annotations in recorded eeg data
    getData = mne.events_from_annotations(raw, event_id={'Stimulus/S  1':1,
                                                         'Stimulus/S  2':2,})
    #                                                      'Stimulus/S  3':3,
    #                                                      'Stimulus/S  4':4})
    events = getData[0]
    event_id = getData[1]

    tmin = -0.5
    tmax = 1.0
    baseline = (-0.5, -0.1)
    
    #create epochs with baseline subtraction 
    epochs = mne.Epochs(raw, events=events, event_id=event_id, tmin=tmin, 
                        tmax=tmax, proj=True, baseline=baseline, preload=True)
    
    #create ERP
    evoked = epochs.average()
    evoked.plot()
    
    #set ERP to custom montage and plot topoplots
    evoked.set_montage(montage)
    times = np.arange(0.0, 0.31, 0.05)
    evoked.plot_topomap(times=times, ch_type='eeg')
    
def ica(data):
    #define ica method, default fastica
    ica = mne.preprocessing.ICA(method="fastica")
    
    #fit data to ica
    ica.fit(raw)
    
    #plot ica components, set inst=data to make plots interactive
    ica.plot_components(ch_type='eeg', inst=raw, topomap_args={'data':raw})
    
    ica.apply(inst=raw, exclude=[])
    
    
def erp(data, custom_montage):
    
    #get events and their IDs from annotations in recorded eeg data
    getData = mne.events_from_annotations(raw, event_id={'Stimulus/S  1':1,
                                                         'Stimulus/S  2':2,
                                                         'Stimulus/S  3':3,
                                                         'Stimulus/S  4':4})
    
    events = getData[0]
    event_id = getData[1]

    tmin = -0.5
    tmax = 1.0
    baseline = (-0.5, -0.1)
    
    #create epochs with baseline subtraction 
    epochs = mne.Epochs(raw, events=events, event_id=event_id, tmin=tmin, 
                        tmax=tmax, proj=True, baseline=baseline, preload=True)
    
    #create ERP
    evoked = epochs.average()
    evoked.plot()
    
    #set ERP to custom montage and plot topoplots
    evoked.set_montage(montage)
    times = np.arange(0.0, 0.31, 0.05)
    evoked.plot_topomap(times=times, ch_type='eeg')