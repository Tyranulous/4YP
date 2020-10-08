import matplotlib.pyplot as plt
import numpy as n 
import seaborn as sn
import random as r

# sampling freq range 40micro seconds to 1 millisecond
# centre freq 300e6 to 1.5e9
# bandwidth range 50e6 to 400e6
# channels 512 to 4096

#def uniformDist(lSampTime,uSampTime,lCentFreq,uCentFreq,lBandwidth,uBandwidth,lChannels,uChannels):
#    samplingTime = int(n.random.uniform(lSampTime,uSampTime+1))
#    centFreq = int(n.random.uniform(lCentFreq,uCentFreq+1))
#    bandwidth = int(n.random.uniform(lBandwidth,uBandwidth+1))
    #channels = int(r.uniform(lChannels,uChannels)); 
#    channels = 2^(int(n.random.uniform(9,13)))

x = (n.random.uniform(size=[1,1000]))
x = ((x * 4) + 9)
f = lambda x: 2 ** int(x)
data = f(x)    
#data = n.zeros(1000,)   
#for i in range(1000):
#    data[i] = 2^(int(n.random.uniform(9,13)))


plt.plot(data,'rx')
plt.show()