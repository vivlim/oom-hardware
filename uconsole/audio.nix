{pkgs, ...}: let
  rpi-utils = pkgs.callPackage ../raspberry-pi/packages/rpi-utils {};
  audio-patch = pkgs.writeText "audio_3.5_patch.py" ''
    import os
    import time

    def init_gpio():
        os.popen("${rpi-utils}/bin/pinctrl set 11 op")
        os.popen("${rpi-utils}/bin/pinctrl set 10 ip pn")

    def check_3_5():
        tmp = os.popen("${rpi-utils}/bin/pinctrl 10").readline().strip("\n")
        return tmp

    def enable_speaker_gpio():
        os.popen("${rpi-utils}/bin/pinctrl set 11 op dh")

    def disable_speaker_gpio():
        os.popen("${rpi-utils}/bin/pinctrl set 11 op dl")

    init_gpio()

    while True:
        tmp =  check_3_5()
        if tmp == "10: ip    pn | lo // GPIO10 = input":
            enable_speaker_gpio()
        elif tmp == "10: ip    pn | hi // GPIO10 = input":
            disable_speaker_gpio()
        time.sleep(1)
  '';
in {
  config = {
    systemd.services."audio_3.5_patch" = {
      description = "cpi audio patch";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.python3Minimal}/bin/python ${audio-patch}";
        RemainAfterExit = "no";
      };
    };
  };
}
