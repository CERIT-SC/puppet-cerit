class cerit::passwd (
  $user     = $cerit::params::passwd_user,
  $password = $cerit::params::passwd_password,
  $level    = $cerit::params::passwd_level,
  $levels   = $cerit::params::passwd_levels
) inherits cerit::params {

  validate_hash($levels)

  if $level {
    if has_key($levels, $level) {
      debug("Password level ${level} for ${user} on ${::fqdn}")
      $_password = $levels[$level]
    } else {
      fail("Unknown level ${level} for ${user} on ${::fqdn}")
    }
  } else {
    debug("Default password for ${user} on ${::fqdn}")
    $_password = $password
  }

  if strip($_password) {
    user { $user:
      password => $_password,
    }
  } else {
    fail("Empty password for ${user}")
  }
}
