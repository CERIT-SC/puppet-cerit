# Fact: is_cluster
# Fact: clustername
# Fact: clusternodeid
#
# Purpose: Detect cluster name and node ID.
#
# Resolution:
#   Following facts tries to detect cluster name and node ID from hostname.
#   If machine hostname contains number(s), it's probably member of
#   cluster of similar machines. From hostname we can then simply
#   guess a cluster name by stripping the number(s). If such hostname
#   is found, 'is_cluster' fact is set to true.
#
#   Examples:
#
#     for hostname "example12"
#     - is_cluster    = "true"
#     - clustername   = "example"
#     - clusternodeid = "12"
#
#     for hostname "example12j"
#     - is_cluster    = "true"
#     - clustername   = "examplej"
#     - clusternodeid = "12"
#
# Caveats:
#
#
is_cluster = "false"

if Facter.value(:hostname) =~ /^(\D+)(\d+)(\D*)$/
  is_cluster = "true"

  Facter.add("clustername") do
    setcode do
      "#{$1}#{$3}"
    end
  end

  Facter.add("clusternodeid") do
    setcode do
      "#{$2}"
    end
  end
end

Facter.add("is_cluster") do
  setcode do
    is_cluster
  end
end
