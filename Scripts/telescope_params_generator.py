from numpy import random as r
import matplotlib as plt

# sampling freq range 40micro seconds to 1 millisecond
# centre freq 300e6 to 1.5e9
# bandwidth range 50e6 to 400e6
# channels 512 to 4096

def uniformDist(lSampTime,uSampTime,lCentFreq,uCentFreq,lBandwidth,uBandwidth,lChannels,uChannels):
    samplingTime = int(r.uniform(lSampTime,uSampTime+1));
    centFreq = int(r.uniform(lCentFreq,uCentFreq+1));
    bandwidth = int(r.uniform(lBandwidth,uBandwidth+1)); 
    #channels = int(r.uniform(lChannels,uChannels)); 
    channels = 2^(int(r.uniform(9,13)));
    


