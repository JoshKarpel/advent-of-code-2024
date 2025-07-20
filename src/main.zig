const std = @import("std");

const a = std.heap.page_allocator;

pub fn main() !void {
    try timed(day1);
    try timed(day2);
}

fn timed(f: anytype) !void {
    const start = std.time.nanoTimestamp();
    try f();
    const end = std.time.nanoTimestamp();
    const duration: f64 = @floatFromInt(end - start);
    std.debug.print("Execution time: {} ms\n\n", .{duration / 1e6});
}

fn day1() !void {
    const input = @embedFile("inputs/day_01.txt");

    const t = i32;

    var left = std.ArrayList(t).init(a);
    defer left.deinit();
    var right = std.ArrayList(t).init(a);
    defer right.deinit();

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue; // Skip empty lines

        var parts = std.mem.splitSequence(u8, line, "   ");

        const l = try std.fmt.parseInt(t, parts.next().?, 10);
        const r = try std.fmt.parseInt(t, parts.next().?, 10);

        try left.append(l);
        try right.append(r);
    }

    std.mem.sort(t, left.items, {}, comptime std.sort.asc(t));
    std.mem.sort(t, right.items, {}, comptime std.sort.asc(t));

    var difference: u32 = 0;
    for (left.items, right.items) |l, r| {
        difference += @abs(l - r);
    }

    var right_counts = std.AutoHashMap(t, t).init(a);
    defer right_counts.deinit();
    for (right.items) |r| {
        const count = try right_counts.getOrPutValue(r, 0);
        try right_counts.put(r, count.value_ptr.* + 1);
    }

    var similarity: t = 0;
    for (left.items) |l| {
        const count = right_counts.get(l) orelse 0;
        similarity += l * count;
    }

    std.debug.print("Day 1:\n", .{});
    std.debug.print("  Part 1: {}\n", .{difference});
    std.debug.print("  Part 2: {}\n", .{similarity});
}

fn day2() !void {
    const input = @embedFile("inputs/day_02.txt");

    const t = i32;

    var num_safe: u32 = 0;
    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue; // Skip empty lines

        var levels = std.mem.splitSequence(u8, line, " ");

        var last_sign: t = 0;
        var prev = try std.fmt.parseInt(t, levels.first(), 10);

        var good = true;

        while (levels.next()) |level| {
            const curr = try std.fmt.parseInt(t, level, 10);
            const diff = curr - prev;

            const abs_diff = @abs(diff);
            if (abs_diff < 1 or abs_diff > 3) {
                std.debug.print("Invalid difference for {s}: {}\n", .{ line, abs_diff });
                good = false;
                break;
            }

            const sign_diff: t = if (diff > 0) 1 else if (diff < 0) -1 else 0;
            if (last_sign != 0 and last_sign != sign_diff) {
                std.debug.print("Inconsistent sign for {s}: {} vs {}\n", .{ line, last_sign, sign_diff });
                good = false;
                break;
            }

            last_sign = sign_diff;
            prev = curr;
        }

        if (good) num_safe += 1;
    }

    std.debug.print("Day 2:\n", .{});
    std.debug.print("  Part 1: {}\n", .{num_safe}); // Placeholder for part 1
}
