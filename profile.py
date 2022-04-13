#!/usr/bin/env python

kube_description= \
"""
Phobos POwder profile
"""
kube_instruction= \
"""
To be done
"""

#
# Standard geni-lib/portal libraries
#
import geni.portal as portal
import geni.rspec.pg as PG
import geni.rspec.emulab as elab
import geni.rspec.igext as IG
import geni.urn as URN



#
# PhantomNet extensions.
#
import geni.rspec.emulab.pnext as PN


#
# This geni-lib script is designed to run in the PhantomNet Portal.
#
pc = portal.Context()



params = pc.bindParameters()

#
# Give the library a chance to return nice JSON-formatted exception(s) and/or
# warnings; this might sys.exit().
#
pc.verifyParameters()





tour = IG.Tour()
tour.Description(IG.Tour.TEXT,kube_description)
tour.Instructions(IG.Tour.MARKDOWN,kube_instruction)
rspec.addTour(tour)

# Network
netmask="255.255.255.0"
epclink = rspec.Link("s1-lan")

# Core
rspec = PG.Request()
epc = rspec.RawPC("epc")
epc.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD'
#epc.addService(PG.Execute(shell="sh", command="/usr/bin/sudo /local/repository/scripts/open5gs_setup.sh")
epc.hardware_type = params.Hardware
epc.Site('Core')
iface = epc.addInterface()
iface.addAddress(PG.IPv4Address("192.168.4.80", netmask))
epclink.addInterface(iface)


  
ran = rspec.XenVM('multiplexer')
ran.cores = 2
ran.ram = 1024 * 4
ran.routable_control_ip = True
ran.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD'
ran.Site('Nervion')
iface = ran.addInterface()
iface.addAddress(PG.IPv4Address("192.168.4.81", netmask))
epclink.addInterface(iface)
#ran.addService(PG.Execute(shell="bash", command="/local/repository/scripts/multiplexer/run.sh"))



epclink.link_multiplexing = True
epclink.vlan_tagging = True
epclink.best_effort = True



#
# Print and go!
#
pc.printRequestRSpec(rspec)