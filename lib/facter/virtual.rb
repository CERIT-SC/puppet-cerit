# Fact: virtual
#
# Purpose: KVM virtualization hacks
#
# Resolution:
#   When QEMU uses host-passthrough CPU modelling, it has same
#   name and flags as physical CPU. Facter then wrongly detects
#   VM as physical machine.
#
# Caveats:
#   This is just hack for CERIT-SC, it could probably
#   wrongly detect Xen HVM instances or anything based
#   on QEMU as "kvm".
#
Facter.add("virtual") do
  has_weight 666
  confine :productname => ["Bochs","KVM"]
  setcode do
    "kvm"
  end
end
