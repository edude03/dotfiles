{
  description = "Debugging container image with edude03's home-manager environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";

    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-config = {
      url = "path:../home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix2container,
    home-manager-config,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # Container images target Linux. On Darwin hosts, evaluate against the
      # equivalent Linux pkgs and rely on a remote/linux-builder to actually build.
      imageSystem =
        if system == "aarch64-darwin"
        then "aarch64-linux"
        else if system == "x86_64-darwin"
        then "x86_64-linux"
        else system;

      pkgsLinux = nixpkgs.legacyPackages.${imageSystem};
      n2c = nix2container.packages.${system}.nix2container;

      username = "edude03";
      uid = 1000;
      gid = 1000;

      homeConfig = home-manager-config.packages.${imageSystem}.homeConfigurations.${username};
      hmActivation = homeConfig.activationPackage;

      passwd = pkgsLinux.writeText "passwd" ''
        root:x:0:0:root:/root:${pkgsLinux.bashInteractive}/bin/bash
        ${username}:x:${toString uid}:${toString gid}:${username}:/home/${username}:${pkgsLinux.bashInteractive}/bin/bash
        nobody:x:65534:65534:Nobody:/:/bin/false
      '';

      groupFile = pkgsLinux.writeText "group" ''
        root:x:0:
        ${username}:x:${toString gid}:
        nobody:x:65534:
      '';

      nixConf = pkgsLinux.writeText "nix.conf" ''
        experimental-features = nix-command flakes
        sandbox = false
        build-users-group =
        substituters = https://cache.nixos.org/
        trusted-users = root ${username}
      '';

      debugTools = with pkgsLinux; [
        # Shell + core
        bashInteractive
        coreutils-full
        gnugrep
        gnused
        gawk
        findutils
        gnutar
        gzip
        bzip2
        xz
        unzip
        less
        which
        file

        # Network debugging
        curl
        wget
        netcat-openbsd
        socat
        bind.dnsutils
        iputils
        iproute2
        mtr
        tcpdump

        # Process / syscall debugging
        strace
        ltrace
        lsof
        procps
        psmisc

        # Data wrangling
        jq
        yq-go
        ripgrep
        fd

        # Crypto / transport
        openssl
        openssh
        cacert

        # Nix toolchain
        nix
        git

        # Tiny-utility fallback (nslookup, vi, etc.)
        busybox
      ];

      imageRoot = pkgsLinux.symlinkJoin {
        name = "debug-image-root";
        paths = [
          (pkgsLinux.buildEnv {
            name = "debug-image-env";
            paths = debugTools ++ [homeConfig.config.home.path];
            pathsToLink = ["/bin" "/sbin" "/lib" "/share" "/etc" "/include"];
            ignoreCollisions = true;
          })
        ];
        postBuild = ''
          mkdir -p \
            $out/home/${username} \
            $out/etc/nix \
            $out/usr/bin \
            $out/tmp \
            $out/var/tmp \
            $out/var/empty \
            $out/run \
            $out/root

          # Materialize home-manager's generated home tree.
          cp -a ${hmActivation}/home-files/. $out/home/${username}/
          # cp -a inherits read-only modes from the /nix/store source, so make
          # the home root (and any subdirs) writable enough to add files.
          find $out/home/${username} -type d -exec chmod u+w {} +

          # Convenience symlink so $HOME/.nix-profile/bin works.
          ln -s ${homeConfig.config.home.path} $out/home/${username}/.nix-profile

          install -m 0644 ${passwd}    $out/etc/passwd
          install -m 0644 ${groupFile} $out/etc/group
          install -m 0644 ${nixConf}   $out/etc/nix/nix.conf

          # Compatibility shims many scripts assume.
          ln -sf /bin/env $out/usr/bin/env
          [ -e $out/bin/sh ] || ln -sf ${pkgsLinux.bashInteractive}/bin/bash $out/bin/sh

          chmod 1777 $out/tmp $out/var/tmp
        '';
      };
    in {
      packages.debug-image = n2c.buildImage {
        name = "debug-image";
        tag = "latest";

        copyToRoot = [imageRoot];

        perms = [
          {
            path = imageRoot;
            regex = "/home/${username}";
            mode = "0755";
            uid = uid;
            gid = gid;
            uname = username;
            gname = username;
          }
        ];

        config = {
          User = "root";
          WorkingDir = "/home/${username}";
          Cmd = ["${pkgsLinux.bashInteractive}/bin/bash" "-l"];
          Env = [
            "USER=${username}"
            "HOME=/home/${username}"
            "PATH=/home/${username}/.nix-profile/bin:/bin:/sbin"
            "SHELL=${pkgsLinux.bashInteractive}/bin/bash"
            "TERM=xterm-256color"
            "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
            "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
            "NIX_PATH=nixpkgs=${nixpkgs}"
          ];
        };
      };

      packages.default = self.packages.${system}.debug-image;
    });
}
