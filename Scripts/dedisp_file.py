
from __future__ import print_function
from builtins import zip
from builtins import range
import os

def myexecute(cmd):
    print("'%s'"%cmd)
    os.system(cmd)

# By default, do not output subbands
outsubs = True

nsub = 256

basename = 'file'
rawfiles = 'file.name'

# dDM steps from DDplan.py
dDMs        = [0.5]
# dsubDM steps
dsubDMs     = [102.0]
# downsample factors
downsamps   = [1]
# number of calls per set of subbands
subcalls    = [10]
# The low DM for each set of DMs
startDMs    = [0.0]
# DMs/call
dmspercalls = [204]


# Loop over the DDplan plans
for dDM, dsubDM, dmspercall, downsamp, subcall, startDM in zip(dDMs, dsubDMs, dmspercalls, downsamps, subcalls, startDMs):
    # Loop over the number of calls
    for ii in range(subcall):
        subDM = startDM + (ii+0.5)*dsubDM
        loDM = startDM + ii*dsubDM
        if outsubs:
            # Get our downsampling right
            subdownsamp = downsamp // 2
            datdownsamp = 2
            if downsamp < 2: subdownsamp = datdownsamp = 1
            # First create the subbands
            print("prepsubband -sub -subdm %.2f -nsub %d -downsamp %d -o %s %s" %
                      (subDM, nsub, subdownsamp, basename, rawfiles))
            # And now create the time series
            subnames = basename+"_DM%.2f.sub[0-9]*"%subDM
            print("prepsubband -lodm %.2f -dmstep %.2f -numdms %d -downsamp %d -o %s %s" %
                      (loDM, dDM, dmspercall, datdownsamp, basename, subnames))
        else:
            print("prepsubband -nsub %d -lodm %.2f -dmstep %.2f -numdms %d -downsamp %d -o %s %s/n" %
                      (nsub, loDM, dDM, dmspercall, downsamp, basename, rawfiles))
            
    print("outer loop/n/n")
