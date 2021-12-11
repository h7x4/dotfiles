{ lib, ... }:
let
  users = import ./users.nix;
  inherit (users.pvv) normalUser adminUser;

  # http://www.pvv.ntnu.no/pvv/Maskiner
  normalMachines = [
    [ "hildring" "pvv-login" "pvv" ]
    "demiurgen"
    "eirin"
    [ "jokum" "pvv-nix" ]
    "isvegg"
    [ "microbel" "pvv-users" "pvv-mail" ]
  ];

  rootMachines = [
    [ "knakelibrak" "pvv-databases" ]
    [ "spikkjeposche" "pvv-web" "pvv-wiki" "pvv-webmail" ]
    "sleipner"
    "fenris"
    "balduzius"
    "joshua"
    "skrotnisse"
    "principal"
    "tom"
    "monty"

    {
      names = ["dvask"];
      proxyJump = "monty";
    }

    [ "innovation" "pvv-minecraft" ]
  ];

  normalizeValueType = let
    inherit (lib.strings) isString concatStringsSep;
    inherit (lib.lists) isList;
    inherit (lib.attrsets) filterAttrs;
  in
    machine:
    if (isString machine) then (normalizeValueType [machine])
    else if (isList machine) then (normalizeValueType { names = machine; })
    else ({ name = concatStringsSep " " machine.names; } // (removeAttrs machine ["names"]));

  # TODO: Merge the following two functions. They have too much code in common.
  convertNormalMachines = let
    inherit (lib.trivial) pipe;
    inherit (lib.attrsets) listToAttrs;
    inherit (lib.lists) head;
    inherit (lib.strings) split;

    convertNormalMachine = normalizedMachine:
      rec {
        inherit (normalizedMachine) name;
        value = ({
          hostname = "${head (split " " name)}.pvv.org";
          user = normalUser;
        } // removeAttrs normalizedMachine ["name"]);
      };

    pipeline = [
      (ms: map normalizeValueType ms)
      (ms: map convertNormalMachine ms)
      listToAttrs
    ];
  in machines: pipe machines pipeline;

  convertAdminMachines = let
    inherit (lib.trivial) pipe;
    inherit (lib.attrsets) listToAttrs;
    inherit (lib.lists) head;
    inherit (lib.strings) split;

    convertAdminMachine = normalizedMachine:
      rec {
        inherit (normalizedMachine) name;
        value = ({
          hostname = "${head (split " " name)}.pvv.org";
          user = adminUser;
          proxyJump = "hildring";
        } // removeAttrs normalizedMachine ["name"]);
      };

    pipeline = [
      (ms: map normalizeValueType ms)
      (ms: map convertAdminMachine ms)
      listToAttrs
    ];
  in machines: pipe machines pipeline;

in
  {
    programs.ssh.matchBlocks = let
      concatSets = lib.lists.foldl (s1: s2: s1 // s2) {};
    in concatSets [
      (convertNormalMachines normalMachines)
      (convertAdminMachines rootMachines)
    ];
  }
