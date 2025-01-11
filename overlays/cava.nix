self: super: {
  cava = super.stdenv.mkDerivation rec {
    pname = "cava";
    version = "0.10.2";
    src = self.fetchFromGitHub {
      owner = "karlstav";
      repo = "cava";
      rev = "v0.10.2";
      sha256 = "sha256-value-here"; # Replace with the correct hash
    };
    nativeBuildInputs = [
      self.autoconf
      self.automake
      self.m4
      self.autoconf-archive
    ];
    preConfigure = ''
      mkdir -p m4
    '';
    preBuild = ''
      autoreconf -fi
    '';
    meta = with self.lib; {
      description = "Console-based audio visualizer for ALSA";
      license = licenses.gpl3;
      maintainers = [ maintainers.your-name ];
    };
  };
}

