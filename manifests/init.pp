class vim {

  package { ['vim', 'ctags' ]:
    ensure => latest,
  }

  file {'/etc/vimrc':
    ensure => absent
  }

  vcsrepo { 'vjt-vimfiles':
    require  => [ Package['vim'], Package['git'], Package['ctags'] ],
    ensure   => latest,
    provider => git,
    source   => 'git://github.com/vjt/vimfiles.git',
    path     => '/usr/share/vim/site',
    force    => true,
    revision => master,
  }

  define rc($home, $ensure = present, $group = undef) {
    $user = $title
    $link = $ensure ? {
      present => link,
      default => absent,
    }

    file { "${user}/vimrc":
      require => [ File["${user}/home"], Vcsrepo['vjt-vimfiles'] ],
      ensure  => $link,
      path    => "${home}/.vimrc",
      target  => '/usr/share/vim/site/vimrc',
      owner   => $user,
      group   => $group ? { undef => $user, default => $group },
    }
  }

}
