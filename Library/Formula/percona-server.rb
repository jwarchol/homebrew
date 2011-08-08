require 'formula'

class PerconaServer < Formula
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.1/Percona-Server-5.1.55-12.6/source/Percona-Server-5.1.55-rel12.6.tar.gz'
  homepage 'http://www.percona.com'
  md5 '616c3221774cb3fd72c92798cf9059d7'
  version '5.1.55-12.6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}"
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
      <key>Program</key>
      <string>#{bin}/mysqld_safe</string>
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
