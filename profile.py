#!/usr/bin/env python

kube_description= "Phobos Powder profile"
kube_instruction= "To be done"

#
# Standard geni-lib/portal libraries
#
import geni.portal as portal
import geni.rspec.pg as PG
import geni.rspec.igext as IG


pc = portal.Context()
rspec = PG.Request()


# Profile parameters.
pc.defineParameter("Hardware", "EPC hardware",
                   portal.ParameterType.STRING,"d430",[("d430","d430"),("d710","d710"), ("d820", "d820"), ("pc3000", "pc3000")])

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
epclink = rspec.Link("Backhaul")

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



# RAN
rspec = PG.Request()
ran = rspec.RawPC("ran")
ran.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD'
#ran.addService(PG.Execute(shell="sh", command="/usr/bin/sudo /local/repository/scripts/open5gs_setup.sh")
ran.hardware_type = params.Hardware
ran.Site('RAN')
iface = ran.addInterface()
iface.addAddress(PG.IPv4Address("192.168.4.81", netmask))
epclink.addInterface(iface)



epclink.link_multiplexing = True
epclink.vlan_tagging = True
epclink.best_effort = True



#
# Print and go!
#
pc.printRequestRSpec(rspec)