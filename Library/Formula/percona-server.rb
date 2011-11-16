require 'formula'

class PerconaServer < Formula
  url 'http://www.percona.com/downloads/Percona-Server-5.5/Percona-Server-5.5.16-22.0/source/Percona-Server-5.5.16-rel22.0.tar.gz'
  homepage 'http://www.percona.com'
  md5 '4268926cb5d56df3db61396a41b1475b'
  version '5.5.16-rel22.0'

  def install
    system "cmake", '.', '-DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_CONFIG=mysql_release -DFEATURE_SET=community -DWITH_EMBEDDED_SERVER=OFF'
    system "make install"
    (prefix+'com.percona.mysqld.plist').write startup_plist
    (prefix+'etc/my.cnf').write defaults_file

  end

  def startup_plist; <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>com.percona.mysqld</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/mysqld_safe</string>
        <string>--datadir=#{var}/mysql</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOPLIST
  end

  def defaults_file; <<-EODEFAULTS.undent
    [mysqld]
    max_allowed_packet=16M
    default-storage-engine=InnoDB
    EODEFAULTS
  end

end
