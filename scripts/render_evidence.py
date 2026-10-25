from __future__ import annotations

import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / "evidence"
FONT_PATH = ROOT / "docs" / "assets" / "lecture" / "D2Coding-Regular.ttf"
FONT_BOLD_PATH = ROOT / "docs" / "assets" / "lecture" / "D2Coding-Bold.ttf"
FONT = ImageFont.truetype(str(FONT_PATH), 21)
FONT_SMALL = ImageFont.truetype(str(FONT_PATH), 15)
FONT_PASS = ImageFont.truetype(str(FONT_BOLD_PATH), 28)


def read_text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def function_block(source: str, signature: str) -> str:
    start = source.index(signature)
    brace = source.index("{", start)
    depth = 0
    for pos in range(brace, len(source)):
        if source[pos] == "{":
            depth += 1
        elif source[pos] == "}":
            depth -= 1
            if depth == 0:
                return source[start : pos + 1].strip()
    raise ValueError(f"unterminated function: {signature}")


def render_code(name: str, source: str) -> None:
    lines = source.splitlines()
    widths = [ImageDraw.Draw(Image.new("RGB", (1, 1))).textlength(line, font=FONT) for line in lines]
    width = max(720, int(max(widths, default=0)) + 56)
    height = 30 + len(lines) * 30
    image = Image.new("RGB", (width, height), "#101820")
    draw = ImageDraw.Draw(image)
    y = 14
    for line in lines:
        stripped = line.lstrip()
        color = "#8b949e" if stripped.startswith("//") else "#d6deeb"
        if re.match(r"\s*(void|int|module|endmodule|input|output|always|case|if|else|assign|wire|reg|endcase|end)\b", line):
            color = "#82aaff" if not stripped.startswith("//") else color
        draw.text((24, y), line, font=FONT, fill=color)
        y += 30
    image.save(EVIDENCE / name)


def render_pass(name: str, log_path: str) -> None:
    text = next((line.strip() for line in read_text(log_path).splitlines() if line.startswith("PASS ")), None)
    if text is None:
        raise ValueError(f"PASS line missing from {log_path}")
    image = Image.new("RGB", (min(1550, max(720, len(text) * 18 + 60)), 76), "#101820")
    ImageDraw.Draw(image).text((26, 20), text, font=FONT_PASS, fill="#56d364")
    image.save(EVIDENCE / name)


def parse_vcd(path: Path):
    ids: dict[str, str] = {}
    widths: dict[str, int] = {}
    changes: dict[str, list[tuple[int, str]]] = {}
    stamp = 0
    in_definitions = True
    scope: list[str] = []
    with path.open(encoding="ascii", errors="replace") as file:
        for raw in file:
            line = raw.strip()
            if in_definitions:
                if line.startswith("$scope"):
                    bits = line.split()
                    scope.append(bits[2])
                elif line.startswith("$upscope"):
                    if scope:
                        scope.pop()
                elif line.startswith("$var"):
                    bits = line.split()
                    width, ident, name = int(bits[2]), bits[3], bits[4]
                    full_name = ".".join(scope + [name])
                    ids[full_name] = ident
                    widths[ident] = max(widths.get(ident, 0), width)
                    changes.setdefault(ident, [])
                elif line.startswith("$enddefinitions"):
                    in_definitions = False
                continue
            if line.startswith("#"):
                stamp = int(line[1:])
            elif line and line[0] in "01xzXZ":
                value, ident = line[0].lower(), line[1:]
                if ident in changes:
                    changes[ident].append((stamp, value))
            elif line.startswith("b"):
                bits = line.split()
                if len(bits) == 2 and bits[1] in changes:
                    changes[bits[1]].append((stamp, bits[0][1:].lower()))
    return ids, widths, changes


def pick_signal(ids: dict[str, str], suffix: str) -> str:
    matches = [ident for name, ident in ids.items() if name.endswith("." + suffix)]
    if not matches:
        raise ValueError(f"signal not found: {suffix}")
    return matches[0]


def render_wave(lab: str, name: str, signals: list[tuple[str, str]], window: tuple[int, int] | None = None) -> None:
    xsim_vcd = ROOT / "FPGA" / lab / "vivado" / f"stm32_2_{lab}.sim" / "sim_1" / "behav" / "xsim" / "wave.vcd"
    vcd = xsim_vcd if xsim_vcd.exists() else ROOT / "FPGA" / lab / "sim" / "wave.vcd"
    ids, widths, changes = parse_vcd(vcd)
    traces = [(label, pick_signal(ids, signal), signal) for label, signal in signals]
    full_end = max((time for _, rows in changes.items() for time, _ in rows), default=1)
    start, end = window or (0, full_end)
    end = min(end, full_end)
    if end <= start:
        raise ValueError(f"invalid waveform window: {window}")
    row_height = 76
    left, right, top, bottom = 210, 24, 26, 42
    width = 1600
    height = top + row_height * len(traces) + bottom
    image = Image.new("RGB", (width, height), "#0b1118")
    draw = ImageDraw.Draw(image)
    x0, x1 = left, width - right
    plot_width = x1 - x0
    for index in range(6):
        x = x0 + plot_width * index / 5
        draw.line((x, top - 5, x, height - bottom + 4), fill="#293746", width=1)
        time_ns = (start + (end - start) * index / 5) / 1000
        label = f"{time_ns:.3f} ns" if time_ns < 1000 else f"{time_ns/1000:.3f} us"
        draw.text((int(x - 30), height - bottom + 8), label, font=FONT_SMALL, fill="#8091a5")
    for row, (label, ident, _) in enumerate(traces):
        ytop = top + row * row_height
        yhigh, ylow = ytop + 20, ytop + 51
        draw.line((x0, ytop + 65, x1, ytop + 65), fill="#202c38", width=1)
        draw.text((18, ytop + 24), label, font=FONT, fill="#d6deeb")
        all_points = changes.get(ident, [])
        previous = [point for point in all_points if point[0] <= start]
        points = ([(start, previous[-1][1])] if previous else []) + [point for point in all_points if start < point[0] <= end]
        if not points:
            continue
        for i, (time, value) in enumerate(points):
            next_time = points[i + 1][0] if i + 1 < len(points) else end
            xa = x0 + plot_width * (time - start) / (end - start)
            xb = x0 + plot_width * (next_time - start) / (end - start)
            if widths.get(ident, 1) > 1:
                center = ytop + 36
                half = 12
                draw.line((xa, center - half, xb, center - half), fill="#56d364", width=2)
                draw.line((xa, center + half, xb, center + half), fill="#4ea1ff", width=2)
                draw.line((xa, center - half, xa + 5, center), fill="#7f8fa3", width=1)
                draw.line((xa + 5, center, xa, center + half), fill="#7f8fa3", width=1)
                if i + 1 < len(points):
                    draw.line((xb, center - half, xb + 5, center), fill="#7f8fa3", width=1)
                    draw.line((xb + 5, center, xb, center + half), fill="#7f8fa3", width=1)
                if xb - xa > 38:
                    value_label = "Z" if "z" in value else "X" if "x" in value else f"0x{int(value, 2):X}"
                    label_width = draw.textlength(value_label, font=FONT_SMALL)
                    draw.text((int((xa + xb - label_width) / 2), center - 9), value_label, font=FONT_SMALL, fill="#f2cc60")
                continue
            is_high = value in {"1", "x", "z"} or (value and value[0] == "1")
            yy = yhigh if is_high else ylow
            draw.line((xa, yy, max(xa + 1, xb), yy), fill="#56d364" if is_high else "#4ea1ff", width=3)
            if i + 1 < len(points):
                next_value = points[i + 1][1]
                next_high = next_value in {"1", "x", "z"} or (next_value and next_value[0] == "1")
                next_y = yhigh if next_high else ylow
                draw.line((xb, yy, xb, next_y), fill="#7f8fa3", width=2)
    image.save(EVIDENCE / name)


def main() -> None:
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    task5 = function_block(read_text("Core/Src/ece2_474_routine.c"), "void polling_routine(void)")
    task6 = function_block(read_text("lab/task6_polling_routine.c"), "void polling_routine(void)")
    task7 = function_block(read_text("lab/task7_polling_routine.c"), "void polling_routine(void)")
    command = read_text("FPGA/uart_command/rtl/uart_led_command.v")
    command = command[command.index("module uart_led_command"):command.index("endmodule") + len("endmodule")]
    render_code("code_task5_mcu.png", task5)
    render_code("code_task6_mcu.png", task6)
    render_code("code_task7_mcu.png", task7)
    render_code("code_task7_fpga.png", command)
    render_code("code_servo.png", read_text("FPGA/servo/rtl/servo_ctrl.v").strip())
    render_code("code_sram.png", read_text("FPGA/sram/rtl/sram.v").strip())
    render_code("code_dac.png", read_text("FPGA/dac/rtl/dac.v").strip())
    render_pass("pass_servo.png", "FPGA/servo/vivado/stm32_2_servo.sim/sim_1/behav/xsim/simulate.log")
    render_pass("pass_sram.png", "FPGA/sram/vivado/stm32_2_sram.sim/sim_1/behav/xsim/simulate.log")
    render_pass("pass_dac.png", "FPGA/dac/vivado/stm32_2_dac.sim/sim_1/behav/xsim/simulate.log")
    render_pass("pass_uart_led.png", "FPGA/uart_command/vivado/stm32_2_uart_command.sim/sim_1/behav/xsim/simulate.log")
    render_wave("servo", "wave_servo.png", [("reset", "rst"), ("left", "l"), ("right", "r"), ("pulse_us", "us"), ("servo", "servo")])
    render_wave("sram", "wave_sram.png", [("write", "wr"), ("read", "rd"), ("address", "address"), ("input", "data_in"), ("CS_n", "cs_n"), ("OE_n", "oe_n"), ("WE_n", "we_n"), ("RAM bus", "bus"), ("LED", "led")], (0, 70_000))
    render_wave("sram", "wave_sram_read.png", [("read", "rd"), ("address", "address"), ("CS_n", "cs_n"), ("OE_n", "oe_n"), ("WE_n", "we_n"), ("RAM bus", "bus"), ("LED", "led")], (94_000, 134_000))
    render_wave("dac", "wave_dac.png", [("reset", "rst"), ("channel", "channel"), ("WE_n", "we_n"), ("A/B", "a_b"), ("data", "data"), ("LED", "led")], (0, 300_000))
    render_wave("dac", "wave_dac_channel.png", [("channel", "channel"), ("WE_n", "we_n"), ("A/B", "a_b"), ("data", "data"), ("LED", "led")], (5_100_000, 5_400_000))
    render_wave("uart_command", "wave_uart_led.png", [("rx_valid", "rx_valid"), ("rx_data", "rx_data"), ("rx_seen", "rx_seen"), ("last_byte", "last_byte"), ("LED", "led")])


if __name__ == "__main__":
    main()
