# Puppet S3 File synchronization

Example Usage:

    s3file { '/path/to/destination/file':
      source => 'object_storage/the/file',
      ensure => 'latest',
    }
