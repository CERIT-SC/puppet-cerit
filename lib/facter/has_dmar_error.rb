# Fact: has_dmar_error
#
# Purpose: Detect DMAR errors
#
# Resolution:
#   Returns true/false if DMAR error has occured
#
# Caveats:
#   Makes sense only on physical Linux machines.
#
Facter.add("has_dmar_error") do
  confine :kernel => :linux
  confine :is_virtual => :false

  setcode do
    out = Facter::Core::Execution.exec('dmesg | egrep \'(DRHD|DMAR):.*fault (status|addr|reason)\'')
    if out
      "true"
    else
      "false"
    end
  end
end
