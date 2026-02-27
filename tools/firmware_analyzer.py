#!/usr/bin/env python3
import os
import sys
import struct
import glob as globmod
import json
import xml.etree.ElementTree as ET

try:
    import capstone
    HAS_CAPSTONE = True
except ImportError:
    HAS_CAPSTONE = False


def find_firmware_root():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    return os.path.dirname(script_dir)


def catalog_web_pages(root):
    results = {}
    web_dir = os.path.join(root, "web")
    if not os.path.isdir(web_dir):
        return results

    for frame_dir in sorted(os.listdir(web_dir)):
        frame_path = os.path.join(web_dir, frame_dir)
        if not os.path.isdir(frame_path):
            continue
        pages = []
        for dirpath, _, filenames in os.walk(frame_path):
            for f in sorted(filenames):
                if f.endswith((".asp", ".html", ".cgi")):
                    rel = os.path.relpath(os.path.join(dirpath, f), web_dir)
                    pages.append(rel)
        if pages:
            results[frame_dir] = pages
    return results


def parse_menu_xml(root):
    menus = {}
    menu_dir = os.path.join(root, "web", "menu")
    if not os.path.isdir(menu_dir):
        return menus

    for xml_file in sorted(os.listdir(menu_dir)):
        if not xml_file.endswith(".xml"):
            continue
        filepath = os.path.join(menu_dir, xml_file)
        try:
            tree = ET.parse(filepath)
            root_el = tree.getroot()
            items = []
            for item in root_el.iter():
                name = item.get("name", item.get("Name", ""))
                url = item.get("url", item.get("Url", ""))
                featurectrl = item.get("featurectrl", "")
                if name or url:
                    entry = {"name": name, "url": url}
                    if featurectrl:
                        entry["featurectrl"] = featurectrl
                    items.append(entry)
            menus[xml_file] = items
        except ET.ParseError:
            menus[xml_file] = [{"error": "parse_failed"}]
    return menus


def find_ports_and_services(root):
    services = []

    spec_patterns = [
        os.path.join(root, "etc", "wap", "spec", "**", "*.cfg"),
        os.path.join(root, "configs", "spec", "**", "*.cfg"),
        os.path.join(root, "rootfs_1", "etc", "wap", "spec", "**", "*.cfg"),
        os.path.join(root, "rootfs_1", "etc", "wap", "customize", "**", "*.cfg"),
    ]

    port_keys = {}
    for pattern in spec_patterns:
        for cfg_file in globmod.glob(pattern, recursive=True):
            try:
                with open(cfg_file, "r", errors="ignore") as f:
                    for line in f:
                        if "PORT" in line.upper() or "port" in line.lower():
                            parts = line.strip().split('"')
                            name_val = {}
                            for i in range(0, len(parts) - 1, 2):
                                key = parts[i].strip().rstrip("=").strip().split(".")[-1]
                                if i + 1 < len(parts):
                                    name_val[key] = parts[i + 1]
                            if "name" in name_val and "value" in name_val:
                                k = name_val["name"]
                                v = name_val["value"]
                                src = os.path.relpath(cfg_file, root)
                                if k not in port_keys:
                                    port_keys[k] = {"value": v, "sources": [src]}
                                else:
                                    if src not in port_keys[k]["sources"]:
                                        port_keys[k]["sources"].append(src)
            except (IOError, OSError):
                pass

    for k, v in sorted(port_keys.items()):
        services.append({
            "parameter": k,
            "port": v["value"],
            "sources": v["sources"],
        })

    uhttpd_configs = globmod.glob(os.path.join(root, "rootfs_*", "**", "uhttpd"), recursive=True)
    for cfg in uhttpd_configs:
        try:
            with open(cfg, "r", errors="ignore") as f:
                content = f.read()
                services.append({
                    "parameter": "uhttpd_config",
                    "port": "see_config",
                    "file": os.path.relpath(cfg, root),
                    "listeners": [
                        line.strip()
                        for line in content.splitlines()
                        if "list listen" in line
                    ],
                })
        except (IOError, OSError):
            pass

    return services


def find_debug_methods(root):
    methods = []

    methods.append({
        "method": "midinfo.debug",
        "type": "software",
        "description": "Create /mnt/jffs2/midinfo.debug with 'mid set' commands. "
                       "On boot, 1.sdk_init.sh reads each line and executes 'mid set <param> 1'. "
                       "File is deleted after processing.",
        "location": "etc/rc.d/rc.start/1.sdk_init.sh:148-152",
    })

    methods.append({
        "method": "Telnet via BusyBox",
        "type": "software",
        "description": "Equip.sh creates /mnt/jffs2/temp/telnet symlink to busybox if /bin/telnet missing. "
                       "Telnet LAN access controlled by "
                       "InternetGatewayDevice.X_HW_Security.AclServices.TELNETLanEnable (0/1).",
        "location": "bin/Equip.sh:88-91",
    })

    methods.append({
        "method": "Equipment Mode",
        "type": "hardware/software",
        "description": "Equip.sh runs 'bbsp equip &' and 'amp equip &' in equipment/factory mode. "
                       "Triggered by /mnt/jffs2/ProductLineMode file. Equipment archive "
                       "extracted from /mnt/jffs2/equipment.tar.gz.",
        "location": "bin/Equip.sh:1353-1439",
    })

    methods.append({
        "method": "Factory Reset Tag",
        "type": "software",
        "description": "Creating /mnt/jffs2/factory_reset_tag triggers factory reset on boot. "
                       "Removed by 1.sdk_init.sh after reset.",
        "location": "etc/rc.d/rc.start/1.sdk_init.sh:3025",
    })

    methods.append({
        "method": "WiFi Kernel Debug",
        "type": "software",
        "description": "Presence of /mnt/jffs2/wifi_kernel_debug enables WiFi debug logging. "
                       "Debug binaries: bin/wifidebug, bin/chipdebug (in rootfs_1).",
        "location": "bin/Equip.sh:1087",
    })

    methods.append({
        "method": "X_HW_DEBUG TR-069 Framework",
        "type": "software",
        "description": "Full debug command tree under InternetGatewayDevice.X_HW_DEBUG.*. "
                       "Accessible via TR-069/CWMP (cfgtoolc/cfgtools). Sub-paths include: "
                       "SMP.DM.ShowWapVer, SMP.DM.CheckCurCustomize, VSPA.TotalTest.TestState, BBSP.*. "
                       "Some paths accessible without auth in certain ISP configs (jsct, szct).",
        "location": "configs/customize/china/e8c_spec_*.cfg",
    })

    methods.append({
        "method": "cfgtoolc/cfgtools CLI",
        "type": "software",
        "description": "ARM binaries for direct config tree access. Usage: "
                       "'cfgtoolc GetPara <xpath>' / 'cfgtoolc SetPara <xpath> <value>'. "
                       "Can modify TelnetSwitch, SshSwitch, and other debug parameters.",
        "location": "bin/cfgtoolc, bin/cfgtools",
    })

    return methods


def find_no_auth_pages(root):
    pages = []
    patterns = [
        os.path.join(root, "etc", "wap", "spec", "**", "*.cfg"),
        os.path.join(root, "configs", "spec", "**", "*.cfg"),
        os.path.join(root, "rootfs_1", "etc", "wap", "spec", "**", "*.cfg"),
    ]
    for pattern in patterns:
        for cfg_file in globmod.glob(pattern, recursive=True):
            try:
                with open(cfg_file, "r", errors="ignore") as f:
                    for line in f:
                        if "NO_AUTH_PAGE" in line:
                            parts = line.split('"')
                            for p in parts:
                                if ".asp" in p or ".cgi" in p:
                                    for page in p.split(";"):
                                        page = page.strip()
                                        if page and page not in pages:
                                            pages.append(page)
            except (IOError, OSError):
                pass
    return sorted(set(pages))


def read_elf_header(filepath):
    try:
        with open(filepath, "rb") as f:
            magic = f.read(4)
            if magic != b"\x7fELF":
                return None
            f.seek(0)
            ident = f.read(16)
            ei_class = ident[4]
            ei_data = ident[5]

            if ei_class == 1:
                fmt = "<" if ei_data == 1 else ">"
                f.seek(0)
                header = f.read(52)
                fields = struct.unpack(fmt + "16sHHIIIIIHHHHHH", header)
                return {
                    "class": 32,
                    "endian": "little" if ei_data == 1 else "big",
                    "type": fields[1],
                    "machine": fields[2],
                    "entry": fields[4],
                    "phoff": fields[5],
                    "shoff": fields[6],
                    "phnum": fields[10],
                    "shnum": fields[12],
                }
    except (IOError, OSError, struct.error):
        return None
    return None


def find_text_section(filepath):
    try:
        with open(filepath, "rb") as f:
            magic = f.read(4)
            if magic != b"\x7fELF":
                return None, None, None
            f.seek(0)
            header = f.read(52)
            fmt = "<"
            fields = struct.unpack(fmt + "16sHHIIIIIHHHHHH", header)
            shoff = fields[6]
            shentsize = fields[9]
            shnum = fields[12]
            shstrndx = fields[13]

            if shoff == 0 or shnum == 0:
                return None, None, None

            f.seek(shoff + shstrndx * shentsize)
            strtab_hdr = f.read(shentsize)
            strtab_fields = struct.unpack(fmt + "IIIIIIIIII", strtab_hdr)
            strtab_offset = strtab_fields[4]
            strtab_size = strtab_fields[5]

            f.seek(strtab_offset)
            strtab = f.read(strtab_size)

            for i in range(shnum):
                f.seek(shoff + i * shentsize)
                sh = f.read(shentsize)
                sh_fields = struct.unpack(fmt + "IIIIIIIIII", sh)
                name_idx = sh_fields[0]
                name = strtab[name_idx:strtab.index(b"\x00", name_idx)].decode("ascii", errors="ignore")
                if name == ".text":
                    return sh_fields[4], sh_fields[5], sh_fields[3]
    except (IOError, OSError, struct.error, ValueError):
        pass
    return None, None, None


def extract_strings_from_binary(filepath, min_length=6):
    strings = []
    try:
        with open(filepath, "rb") as f:
            data = f.read()
        current = []
        for byte in data:
            if 32 <= byte < 127:
                current.append(chr(byte))
            else:
                if len(current) >= min_length:
                    strings.append("".join(current))
                current = []
        if len(current) >= min_length:
            strings.append("".join(current))
    except (IOError, OSError):
        pass
    return strings


def analyze_binary_with_capstone(filepath, max_instructions=200):
    if not HAS_CAPSTONE:
        return {"error": "capstone not available"}

    text_offset, text_size, text_addr = find_text_section(filepath)
    if text_offset is None:
        try:
            with open(filepath, "rb") as f:
                data = f.read()
            text_offset = 0x1000 if len(data) > 0x1000 else 0
            text_size = min(len(data) - text_offset, 4096)
            text_addr = 0x1000
        except (IOError, OSError):
            return {"error": "cannot read file"}

    try:
        with open(filepath, "rb") as f:
            f.seek(text_offset)
            code = f.read(min(text_size, 8192))
    except (IOError, OSError):
        return {"error": "cannot read .text section"}

    md = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    md.detail = True

    instructions = []
    function_calls = []
    branch_targets = set()

    base_addr = text_addr if text_addr else text_offset
    count = 0
    for insn in md.disasm(code, base_addr):
        if count >= max_instructions:
            break
        instructions.append({
            "address": f"0x{insn.address:08x}",
            "mnemonic": insn.mnemonic,
            "op_str": insn.op_str,
        })
        if insn.mnemonic in ("bl", "blx"):
            function_calls.append({
                "address": f"0x{insn.address:08x}",
                "target": insn.op_str,
            })
        if insn.mnemonic.startswith("b"):
            try:
                target = int(insn.op_str.replace("#", ""), 16)
                branch_targets.add(f"0x{target:08x}")
            except (ValueError, TypeError):
                pass
        count += 1

    interesting_strings = []
    all_strings = extract_strings_from_binary(filepath)
    keywords = [
        "debug", "telnet", "ssh", "password", "key", "encrypt", "decrypt",
        "aes", "rsa", "hmac", "pbkdf", "kmc", "cfgfile", "security",
        "admin", "root", "shell", "login", "auth", "token", "certificate",
        "http", "port", "listen", "socket", "bind", "uhttpd",
    ]
    for s in all_strings:
        sl = s.lower()
        if any(k in sl for k in keywords):
            if len(s) < 200:
                interesting_strings.append(s)

    return {
        "file": os.path.basename(filepath),
        "text_section": {
            "offset": f"0x{text_offset:08x}" if text_offset else "unknown",
            "size": text_size,
            "vaddr": f"0x{text_addr:08x}" if text_addr else "unknown",
        },
        "total_instructions_sampled": len(instructions),
        "function_calls_bl_blx": function_calls[:50],
        "branch_targets": sorted(branch_targets)[:30],
        "first_20_instructions": instructions[:20],
        "interesting_strings": interesting_strings[:100],
    }


def analyze_all_binaries(root):
    results = {}
    priority_bins = [
        "bin/cfgtoolc", "bin/cfgtools", "bin/cms", "bin/bbsp", "bin/oam",
        "bin/hftp", "bin/dms", "bin/bponportal",
    ]

    for rel_path in priority_bins:
        full_path = os.path.join(root, rel_path)
        if os.path.isfile(full_path):
            elf = read_elf_header(full_path)
            if elf:
                analysis = analyze_binary_with_capstone(full_path)
                analysis["elf_header"] = elf
                analysis["size_bytes"] = os.path.getsize(full_path)
                results[rel_path] = analysis

    priority_libs = [
        "lib/libhttp_redirect.so",
        "lib/libhw_smp_cms.so",
        "lib/libhw_smp_psi.so",
        "lib/libhw_ctrg_cu.so",
        "lib/libhw_ctei_report.so",
    ]

    for rel_path in priority_libs:
        full_path = os.path.join(root, rel_path)
        if os.path.isfile(full_path):
            elf = read_elf_header(full_path)
            if elf:
                analysis = analyze_binary_with_capstone(full_path)
                analysis["elf_header"] = elf
                analysis["size_bytes"] = os.path.getsize(full_path)
                results[rel_path] = analysis

    return results


def build_web_access_map():
    return {
        "primary_interface": {
            "ip": "192.168.100.1",
            "port_http": 80,
            "port_https": 4443,
            "description": "Main LAN management interface (default gateway)",
            "access": "http://192.168.100.1 or https://192.168.100.1:4443",
        },
        "wan_side_interface": {
            "ip": "WAN IP (assigned by ISP)",
            "port_http": 8080,
            "port_https": None,
            "description": "WAN-side HTTP management (China Telecom tianyi variant only)",
            "access": "http://<WAN_IP>:8080 (requires SSMP_SPEC_WEB_OUTPORTNUM=8080)",
            "config": "rootfs_1/etc/wap/customize/china/spec_tianyi_base_v5.cfg",
        },
        "captive_portal": {
            "ip": "192.168.100.1",
            "port": 80,
            "base_path": "/portal/",
            "pages": [
                "PortalWebPwd.asp", "PortalWifi.asp", "PortalStaticIP.asp",
                "PortalChange.asp", "PortalFinish.asp", "PortalBbspPwd.asp",
                "PortalUPPort.asp", "PortalInternetStatus.asp",
            ],
            "description": "First-time setup wizard / captive portal (auto-redirect on first connect)",
            "access": "http://192.168.100.1/portal/PortalWebPwd.asp",
        },
        "uhttpd_secondary": {
            "ip": "0.0.0.0 (all interfaces)",
            "port_http": 80,
            "port_https": 4443,
            "description": "uhttpd in rootfs_3 (SAF subsystem) listens on all interfaces",
            "config": "rootfs_3/saf/rootfs/etc/config/uhttpd",
        },
        "dlna_media_server": {
            "ip": "192.168.100.1",
            "port": 56001,
            "description": "DLNA/UPnP media server for USB-attached storage",
            "access": "Auto-discovered via UPnP on port 56001",
        },
        "dlna_client": {
            "port": 56002,
            "description": "DLNA client port",
        },
        "device_communication": {
            "port": 3002,
            "description": "Internal device communication port (DSL/LTE modules)",
            "config_key": "SSMP_SPEC_DEVSCOM_COMPORT",
        },
        "radius_auth": {
            "ip": "192.168.100.100",
            "port_auth": 1812,
            "port_acct": 1813,
            "description": "RADIUS authentication server (hostapd WiFi auth)",
            "config": "rootfs_1/etc/wap/hw_hostapd.conf",
        },
        "preinit_fallback": {
            "ip": "192.168.1.1",
            "description": "Pre-init/failsafe IP address (rootfs_5 UFW subsystem only)",
            "config": "rootfs_5/ufw/rootfs/lib/preinit/00_preinit.conf",
        },
    }


def build_isps_frame_map():
    return {
        "frame_huawei": {
            "target": "Generic / International / Default Huawei",
            "login_url": "/login.asp",
            "features": "Full admin panel, portal wizard, multi-language support",
            "languages": [
                "arabic", "brasil", "chinese", "english", "german",
                "japanese", "portuguese", "russian", "spanish", "turkish",
            ],
        },
        "frame_CMCC": {
            "target": "China Mobile (CMCC)",
            "login_url": "/login.asp",
            "features": "LOID registration, simplified menu, CMCC branding",
        },
        "frame_CTCOM": {
            "target": "China Telecom (CT)",
            "login_url": "/login.asp",
            "features": "Area selection, self-check diagnostics, QR code, route/bridge mode switch",
        },
        "frame_UNICOM": {
            "target": "China Unicom",
            "login_url": "/login.asp",
            "features": "QR code registration, fault reporting, update management",
        },
        "frame_LNUNICOM": {
            "target": "Liaoning China Unicom",
            "login_url": "/login.asp",
            "features": "Regional Unicom variant with XJ/TJ specific pages",
        },
        "frame_XGPON": {
            "target": "XG-PON specific deployments",
            "login_url": "/login_singtel.asp",
            "features": "Minimal pages, Singtel/DNZ Telecom redirects",
        },
        "frame_redhuawei": {
            "target": "Red Huawei branding variant",
            "login_url": "N/A (images only)",
            "features": "Only contains branding images, uses frame_huawei pages",
        },
    }


def run_full_analysis(root):
    output = {
        "firmware": "HN8145XR V500R022C10SPC160",
        "architecture": "ARM Cortex-A9 (32-bit, little-endian, musl libc)",
    }

    output["web_access_map"] = build_web_access_map()
    output["isp_frame_variants"] = build_isps_frame_map()
    output["web_pages_catalog"] = catalog_web_pages(root)
    output["menu_structure"] = parse_menu_xml(root)
    output["no_auth_pages"] = find_no_auth_pages(root)
    output["ports_and_services"] = find_ports_and_services(root)
    output["debug_activation_methods"] = find_debug_methods(root)
    output["binary_analysis"] = analyze_all_binaries(root)

    page_count = sum(len(v) for v in output["web_pages_catalog"].values())
    output["summary"] = {
        "total_web_pages": page_count,
        "frame_variants": len(output["web_pages_catalog"]),
        "menu_configs": len(output["menu_structure"]),
        "no_auth_pages_count": len(output["no_auth_pages"]),
        "binaries_analyzed": len(output["binary_analysis"]),
        "debug_methods_found": len(output["debug_activation_methods"]),
    }

    return output


def main():
    if len(sys.argv) > 1:
        root = sys.argv[1]
    else:
        root = find_firmware_root()

    if not os.path.isdir(root):
        print(f"Error: {root} is not a valid directory", file=sys.stderr)
        sys.exit(1)

    result = run_full_analysis(root)
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
