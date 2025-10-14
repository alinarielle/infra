def sortHome [] {
  j ~/sort
  alias sort = cp -u -r
  watch . -r true {
    j ~/sort/

    glob ~/sort/**/*.{mp4,gif,png,jpg,jpeg,excalidraw,webp} 
    | each {|it| sort $it ~/blob/}

    glob ~/sort/**/*.ics 
    | each {|it| sort $it ~/cal/} #TODO: import into caldav

    glob ~/sort/**/*.{pdf,docx,odf,xlsx,md} 
    | each {|it| sort $it ~/docs/} #TODO: OCR with paperless-ngx

    glob ~/sort/**/*.{flac,mp3,opus,ogg}
    | each {|it| sort $it ~/music/} #TODO: normalize meta tags

    glob ~/sort/**/*.{vcf,pgp,asc,sig,pub}
    | each {|it| sort $it ~/contacts/} #TODO: import contact/pgp key

    glob ~/sort/**/*.{epub,mobi}
    | each {|it| sort $it ~/ebooks/} #TODO: move to epub reader if connected, otherwise store and check later

    glob ~/sort/**/*.{torrent,nfo}
    | each {|it| 
      sort $it ~/arr/
      j ~/torrents/
      job spawn {arr $it} #TODO: ensure VPN/I2P, send magnet to qbittorrent web API
      j ~/sort/
    }

    glob ~/sort/**/*.{json,xml,txt,csv}
    | each {|it| 
      sort $it ~/archive/
    }

    glob ~/sort/**/*.{zip,gz,tar,xz,tgz}
    | each {|it| 
        sort $it ~/archive/
        j ~/archive/
        job spawn {ouch -y d $it}
        j ~/sort/
    }
  }
}
