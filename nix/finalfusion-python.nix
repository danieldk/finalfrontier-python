# Generated by carnix 0.10.2: /home/daniel/.cargo/bin/carnix generate-nix --standalone --src .
{ lib, buildRustCrate, buildRustCrateHelpers, callPackage }:

with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
  cratesIO = (callPackage ./crates-io.nix { });
in
rec {
  crates = cratesIO // rec {
# finalfusion-python-0.4.0

    crates.finalfusion_python."0.4.0" = deps: { features?(features_."finalfusion_python"."0.4.0" deps {}) }: buildRustCrate {
      crateName = "finalfusion-python";
      version = "0.4.0";
      description = "Finalfusion Python module";
      homepage = "https://finalfusion.github.io/";
      authors = [ "Daniël de Kok <me@danieldk.eu>" ];
      edition = "2018";
      src = exclude [ ".git" "target" ] ./.;
      libName = "finalfusion";
      type = [ "cdylib" ];
      dependencies = mapFeatures features ([
        (cratesIO.crates."failure"."${deps."finalfusion_python"."0.4.0"."failure"}" deps)
        (cratesIO.crates."finalfusion"."${deps."finalfusion_python"."0.4.0"."finalfusion"}" deps)
        (cratesIO.crates."itertools"."${deps."finalfusion_python"."0.4.0"."itertools"}" deps)
        (cratesIO.crates."libc"."${deps."finalfusion_python"."0.4.0"."libc"}" deps)
        (cratesIO.crates."ndarray"."${deps."finalfusion_python"."0.4.0"."ndarray"}" deps)
        (cratesIO.crates."numpy"."${deps."finalfusion_python"."0.4.0"."numpy"}" deps)
        (cratesIO.crates."pyo3"."${deps."finalfusion_python"."0.4.0"."pyo3"}" deps)
        (cratesIO.crates."toml"."${deps."finalfusion_python"."0.4.0"."toml"}" deps)
      ]);
    };
    features_."finalfusion_python"."0.4.0" = deps: f: updateFeatures f (rec {
      failure."${deps.finalfusion_python."0.4.0".failure}".default = true;
      finalfusion."${deps.finalfusion_python."0.4.0".finalfusion}".default = true;
      finalfusion_python."0.4.0".default = (f.finalfusion_python."0.4.0".default or true);
      itertools."${deps.finalfusion_python."0.4.0".itertools}".default = true;
      libc."${deps.finalfusion_python."0.4.0".libc}".default = true;
      ndarray."${deps.finalfusion_python."0.4.0".ndarray}".default = true;
      numpy."${deps.finalfusion_python."0.4.0".numpy}".default = true;
      pyo3 = fold recursiveUpdate {} [
        { "${deps.finalfusion_python."0.4.0".pyo3}"."extension-module" = true; }
        { "${deps.finalfusion_python."0.4.0".pyo3}".default = true; }
      ];
      toml."${deps.finalfusion_python."0.4.0".toml}".default = true;
    }) [
      (if deps."finalfusion_python"."0.4.0" ? "failure" then cratesIO.features_.failure."${deps."finalfusion_python"."0.4.0"."failure" or ""}" deps else {})
      (if deps."finalfusion_python"."0.4.0" ? "finalfusion" then cratesIO.features_.finalfusion."${deps."finalfusion_python"."0.4.0"."finalfusion" or ""}" deps else {})
      (if deps."finalfusion_python"."0.4.0" ? "itertools" then cratesIO.features_.itertools."${deps."finalfusion_python"."0.4.0"."itertools" or ""}" deps else {})
      (if deps."finalfusion_python"."0.4.0" ? "libc" then cratesIO.features_.libc."${deps."finalfusion_python"."0.4.0"."libc" or ""}" deps else {})
      (if deps."finalfusion_python"."0.4.0" ? "ndarray" then cratesIO.features_.ndarray."${deps."finalfusion_python"."0.4.0"."ndarray" or ""}" deps else {})
      (if deps."finalfusion_python"."0.4.0" ? "numpy" then cratesIO.features_.numpy."${deps."finalfusion_python"."0.4.0"."numpy" or ""}" deps else {})
      (if deps."finalfusion_python"."0.4.0" ? "pyo3" then cratesIO.features_.pyo3."${deps."finalfusion_python"."0.4.0"."pyo3" or ""}" deps else {})
      (if deps."finalfusion_python"."0.4.0" ? "toml" then cratesIO.features_.toml."${deps."finalfusion_python"."0.4.0"."toml" or ""}" deps else {})
    ];


# end

  };

  finalfusion_python = crates.crates.finalfusion_python."0.4.0" deps;
  __all = [ (finalfusion_python {}) ];
  deps.aho_corasick."0.7.6" = {
    memchr = "2.2.1";
  };
  deps.arrayvec."0.4.11" = {
    nodrop = "0.1.13";
  };
  deps.autocfg."0.1.5" = {};
  deps.backtrace."0.3.33" = {
    backtrace_sys = "0.1.31";
    cfg_if = "0.1.9";
    libc = "0.2.62";
    rustc_demangle = "0.1.15";
  };
  deps.backtrace_sys."0.1.31" = {
    libc = "0.2.62";
    cc = "1.0.38";
  };
  deps.bitflags."1.1.0" = {};
  deps.byteorder."1.3.2" = {};
  deps.cc."1.0.38" = {};
  deps.cfg_if."0.1.9" = {};
  deps.cloudabi."0.0.3" = {
    bitflags = "1.1.0";
  };
  deps.crossbeam_deque."0.6.3" = {
    crossbeam_epoch = "0.7.1";
    crossbeam_utils = "0.6.5";
  };
  deps.crossbeam_epoch."0.7.1" = {
    arrayvec = "0.4.11";
    cfg_if = "0.1.9";
    crossbeam_utils = "0.6.5";
    lazy_static = "1.3.0";
    memoffset = "0.2.1";
    scopeguard = "0.3.3";
  };
  deps.crossbeam_queue."0.1.2" = {
    crossbeam_utils = "0.6.5";
  };
  deps.crossbeam_utils."0.6.5" = {
    cfg_if = "0.1.9";
    lazy_static = "1.3.0";
  };
  deps.ctor."0.1.9" = {
    quote = "0.6.13";
    syn = "0.15.42";
  };
  deps.either."1.5.2" = {};
  deps.failure."0.1.5" = {
    backtrace = "0.3.33";
    failure_derive = "0.1.5";
  };
  deps.failure_derive."0.1.5" = {
    proc_macro2 = "0.4.30";
    quote = "0.6.13";
    syn = "0.15.42";
    synstructure = "0.10.2";
  };
  deps.finalfusion."0.9.0" = {
    byteorder = "1.3.2";
    fnv = "1.0.6";
    itertools = "0.8.0";
    memmap = "0.7.0";
    ndarray = "0.12.1";
    ordered_float = "1.0.2";
    rand = "0.6.5";
    rand_xorshift = "0.1.1";
    reductive = "0.2.0";
    serde = "1.0.99";
    toml = "0.5.1";
  };
  deps.finalfusion_python."0.4.0" = {
    failure = "0.1.5";
    finalfusion = "0.9.0";
    itertools = "0.8.0";
    libc = "0.2.62";
    ndarray = "0.12.1";
    numpy = "0.7.0";
    pyo3 = "0.8.0";
    toml = "0.5.1";
  };
  deps.fnv."1.0.6" = {};
  deps.fuchsia_cprng."0.1.1" = {};
  deps.ghost."0.1.0" = {
    proc_macro2 = "0.4.30";
    quote = "0.6.13";
    syn = "0.15.42";
  };
  deps.indoc."0.3.4" = {
    indoc_impl = "0.3.4";
    proc_macro_hack = "0.5.9";
  };
  deps.indoc_impl."0.3.4" = {
    proc_macro_hack = "0.5.9";
    proc_macro2 = "1.0.3";
    quote = "1.0.2";
    syn = "1.0.5";
    unindent = "0.1.4";
  };
  deps.inventory."0.1.4" = {
    ctor = "0.1.9";
    ghost = "0.1.0";
    inventory_impl = "0.1.4";
  };
  deps.inventory_impl."0.1.4" = {
    proc_macro2 = "1.0.3";
    quote = "1.0.2";
    syn = "1.0.5";
  };
  deps.itertools."0.7.11" = {
    either = "1.5.2";
  };
  deps.itertools."0.8.0" = {
    either = "1.5.2";
  };
  deps.itoa."0.4.4" = {};
  deps.lazy_static."1.3.0" = {};
  deps.libc."0.2.62" = {};
  deps.log."0.4.7" = {
    cfg_if = "0.1.9";
  };
  deps.matrixmultiply."0.1.15" = {
    rawpointer = "0.1.0";
  };
  deps.memchr."2.2.1" = {};
  deps.memmap."0.7.0" = {
    libc = "0.2.62";
    winapi = "0.3.7";
  };
  deps.memoffset."0.2.1" = {};
  deps.ndarray."0.12.1" = {
    itertools = "0.7.11";
    matrixmultiply = "0.1.15";
    num_complex = "0.2.3";
    num_traits = "0.2.8";
  };
  deps.ndarray_parallel."0.9.0" = {
    ndarray = "0.12.1";
    rayon = "1.1.0";
  };
  deps.nodrop."0.1.13" = {};
  deps.num_complex."0.2.3" = {
    num_traits = "0.2.8";
    autocfg = "0.1.5";
  };
  deps.num_traits."0.2.8" = {
    autocfg = "0.1.5";
  };
  deps.num_cpus."1.10.1" = {
    libc = "0.2.62";
  };
  deps.numpy."0.7.0" = {
    cfg_if = "0.1.9";
    libc = "0.2.62";
    ndarray = "0.12.1";
    num_complex = "0.2.3";
    num_traits = "0.2.8";
    pyo3 = "0.8.0";
  };
  deps.ordered_float."1.0.2" = {
    num_traits = "0.2.8";
  };
  deps.paste."0.1.6" = {
    paste_impl = "0.1.6";
    proc_macro_hack = "0.5.9";
  };
  deps.paste_impl."0.1.6" = {
    proc_macro_hack = "0.5.9";
    proc_macro2 = "1.0.3";
    quote = "1.0.2";
    syn = "1.0.5";
  };
  deps.proc_macro_hack."0.5.9" = {
    proc_macro2 = "1.0.3";
    quote = "1.0.2";
    syn = "1.0.5";
  };
  deps.proc_macro2."0.4.30" = {
    unicode_xid = "0.1.0";
  };
  deps.proc_macro2."1.0.3" = {
    unicode_xid = "0.2.0";
  };
  deps.pyo3."0.8.0" = {
    indoc = "0.3.4";
    inventory = "0.1.4";
    libc = "0.2.62";
    num_traits = "0.2.8";
    paste = "0.1.6";
    pyo3cls = "0.8.0";
    spin = "0.5.2";
    unindent = "0.1.4";
    regex = "1.3.1";
    serde = "1.0.99";
    serde_json = "1.0.40";
    version_check = "0.9.1";
  };
  deps.pyo3_derive_backend."0.8.0" = {
    proc_macro2 = "1.0.3";
    quote = "1.0.2";
    syn = "1.0.5";
  };
  deps.pyo3cls."0.8.0" = {
    proc_macro2 = "1.0.3";
    pyo3_derive_backend = "0.8.0";
    quote = "1.0.2";
    syn = "1.0.5";
  };
  deps.quote."0.6.13" = {
    proc_macro2 = "0.4.30";
  };
  deps.quote."1.0.2" = {
    proc_macro2 = "1.0.3";
  };
  deps.rand."0.6.5" = {
    rand_chacha = "0.1.1";
    rand_core = "0.4.0";
    rand_hc = "0.1.0";
    rand_isaac = "0.1.1";
    rand_jitter = "0.1.4";
    rand_os = "0.1.3";
    rand_pcg = "0.1.2";
    rand_xorshift = "0.1.1";
    autocfg = "0.1.5";
    libc = "0.2.62";
    winapi = "0.3.7";
  };
  deps.rand_chacha."0.1.1" = {
    rand_core = "0.3.1";
    autocfg = "0.1.5";
  };
  deps.rand_core."0.3.1" = {
    rand_core = "0.4.0";
  };
  deps.rand_core."0.4.0" = {};
  deps.rand_hc."0.1.0" = {
    rand_core = "0.3.1";
  };
  deps.rand_isaac."0.1.1" = {
    rand_core = "0.3.1";
  };
  deps.rand_jitter."0.1.4" = {
    rand_core = "0.4.0";
    libc = "0.2.62";
    winapi = "0.3.7";
  };
  deps.rand_os."0.1.3" = {
    rand_core = "0.4.0";
    rdrand = "0.4.0";
    cloudabi = "0.0.3";
    fuchsia_cprng = "0.1.1";
    libc = "0.2.62";
    winapi = "0.3.7";
  };
  deps.rand_pcg."0.1.2" = {
    rand_core = "0.4.0";
    autocfg = "0.1.5";
  };
  deps.rand_xorshift."0.1.1" = {
    rand_core = "0.3.1";
  };
  deps.rawpointer."0.1.0" = {};
  deps.rayon."1.1.0" = {
    crossbeam_deque = "0.6.3";
    either = "1.5.2";
    rayon_core = "1.5.0";
  };
  deps.rayon_core."1.5.0" = {
    crossbeam_deque = "0.6.3";
    crossbeam_queue = "0.1.2";
    crossbeam_utils = "0.6.5";
    lazy_static = "1.3.0";
    num_cpus = "1.10.1";
  };
  deps.rdrand."0.4.0" = {
    rand_core = "0.3.1";
  };
  deps.reductive."0.2.0" = {
    log = "0.4.7";
    ndarray = "0.12.1";
    ndarray_parallel = "0.9.0";
    num_traits = "0.2.8";
    ordered_float = "1.0.2";
    rand = "0.6.5";
    rand_xorshift = "0.1.1";
    rayon = "1.1.0";
  };
  deps.regex."1.3.1" = {
    aho_corasick = "0.7.6";
    memchr = "2.2.1";
    regex_syntax = "0.6.12";
    thread_local = "0.3.6";
  };
  deps.regex_syntax."0.6.12" = {};
  deps.rustc_demangle."0.1.15" = {};
  deps.ryu."1.0.0" = {};
  deps.scopeguard."0.3.3" = {};
  deps.serde."1.0.99" = {
    serde_derive = "1.0.98";
  };
  deps.serde_derive."1.0.98" = {
    proc_macro2 = "0.4.30";
    quote = "0.6.13";
    syn = "0.15.42";
  };
  deps.serde_json."1.0.40" = {
    itoa = "0.4.4";
    ryu = "1.0.0";
    serde = "1.0.99";
  };
  deps.spin."0.5.2" = {};
  deps.syn."0.15.42" = {
    proc_macro2 = "0.4.30";
    quote = "0.6.13";
    unicode_xid = "0.1.0";
  };
  deps.syn."1.0.5" = {
    proc_macro2 = "1.0.3";
    quote = "1.0.2";
    unicode_xid = "0.2.0";
  };
  deps.synstructure."0.10.2" = {
    proc_macro2 = "0.4.30";
    quote = "0.6.13";
    syn = "0.15.42";
    unicode_xid = "0.1.0";
  };
  deps.thread_local."0.3.6" = {
    lazy_static = "1.3.0";
  };
  deps.toml."0.5.1" = {
    serde = "1.0.99";
  };
  deps.unicode_xid."0.1.0" = {};
  deps.unicode_xid."0.2.0" = {};
  deps.unindent."0.1.4" = {};
  deps.version_check."0.9.1" = {};
  deps.winapi."0.3.7" = {
    winapi_i686_pc_windows_gnu = "0.4.0";
    winapi_x86_64_pc_windows_gnu = "0.4.0";
  };
  deps.winapi_i686_pc_windows_gnu."0.4.0" = {};
  deps.winapi_x86_64_pc_windows_gnu."0.4.0" = {};
}
