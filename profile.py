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
# Backhaul network
backhaul = rspec.Link("Backhaul")
backhaul.link_multiplexing = True
backhaul.vlan_tagging = True
backhaul.best_effort = True

# Fronthaul network
fronthaul = rspec.Link("Fronthaul")
fronthaul.link_multiplexing = True
fronthaul.vlan_tagging = True
fronthaul.best_effort = True

# Core
epc = rspec.RawPC("epc")
epc.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD'
#epc.addService(PG.Execute(shell="sh", command="/usr/bin/sudo /local/repository/scripts/open5gs_setup.sh")
epc.hardware_type = params.Hardware
epc.Site('Core')
iface = epc.addInterface()
iface.addAddress(PG.IPv4Address("192.168.1.1", netmask))
backhaul.addInterface(iface)



# eNB
enb = rspec.RawPC("enb")
enb.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD'
#ran.addService(PG.Execute(shell="sh", command="/usr/bin/sudo /local/repository/scripts/open5gs_setup.sh")
enb.hardware_type = params.Hardware
enb.Site('eNB')
iface1 = enb.addInterface()
iface1.addAddress(PG.IPv4Address("192.168.1.2", netmask))
backhaul.addInterface(iface1)
iface2 = enb.addInterface()
iface2.addAddress(PG.IPv4Address("192.168.2.1", netmask))
fronthaul.addInterface(iface2)


# Proxy
proxy = rspec.RawPC("proxy")
proxy.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD'
#ran.addService(PG.Execute(shell="sh", command="/usr/bin/sudo /local/repository/scripts/open5gs_setup.sh")
proxy.hardware_type = params.Hardware
proxy.Site('Proxy')
iface = proxy.addInterface()
iface.addAddress(PG.IPv4Address("192.168.2.2", netmask))
fronthaul.addInterface(iface)

# UE
ue = rspec.RawPC("ue")
ue.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD'
#ran.addService(PG.Execute(shell="sh", command="/usr/bin/sudo /local/repository/scripts/open5gs_setup.sh")
ue.hardware_type = params.Hardware
ue.Site('UE')
iface = ue.addInterface()
iface.addAddress(PG.IPv4Address("192.168.2.3", netmask))
fronthaul.addInterface(iface)



#
# Print and go!
#
pc.printRequestRSpec(rspec)