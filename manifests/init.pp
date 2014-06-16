# Definition: s3file
#
# This definition fetches and keeps synchonized a file stored in object storage
#
# Parameters:
# - $name: The local target of the file
# - $source: The object storage and filename on object storage
# - $ensure: 'present', 'absent', or 'latest': as the core File resource
# - $s3_domain: HP object storage server to fetch the file from
#
# Requires:
# - cURL
#
# Sample Usage:
#
#  s3file { 'test.file':
#    source => 'object_starage_name/test.file',
#    ensure => 'latest',
#  }
#
define s3file (
  $source,
  $ensure = 'latest',
  $s3_domain = 'region-b.geo-1.objects.hpcloudsvc.com',
)
{
  $valid_ensures = [ 'absent', 'present', 'latest' ]
  validate_re($ensure, $valid_ensures)

  if $ensure == 'absent' {
    # We use a puppet resource here to force the file to absent state
    file { $name:
      ensure => absent
    }
  } else {
    $real_source = "https://${s3_domain}/${source}"

    if $ensure == 'present' {
     # $unless = "[ -e ${name} ] && curl -I ${real_source} | grep ETag | grep `md5sum ${name} | cut -c1-32`"
    #} else {
      $unless = "[ -e ${name} ]"
    }

    exec { "fetch ${name}":
      
      command => "c:/windows/system32/curl.exe  -L -o ${name} ${real_source} -k",
#      unless  => $unless,
      creates => $name,
      provider => powershell,
    }
  }
}
