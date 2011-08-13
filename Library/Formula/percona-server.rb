require 'formula'

class PerconaServer < Formula
  url 'http://www.percona.com/downloads/Percona-Server-5.1/Percona-Server-5.1.57-12.8/source/Percona-Server-5.1.57.tar.gz'
  homepage 'http://www.percona.com'
  md5 '4268926cb5d56df3db61396a41b1475b'
  version '5.1.57-12.8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}",
                          "--without-plugin-innobase", "--with-plugin-innodb_plugin"
    system "make install"
    (prefix+'com.percona.mysqld.plist').write startup_plist

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
        <string>--max_allowed_packet=16M</string>
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

end
