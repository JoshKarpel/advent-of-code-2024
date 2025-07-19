const std = @import("std");

pub fn main() !void {
    try day1();
}

fn day1() !void {
    const a = std.heap.page_allocator;
    const t = i32;
    const input = @embedFile("inputs/day_01.txt");

    var left = std.ArrayList(t).init(a);
    defer left.deinit();
    var right = std.ArrayList(t).init(a);
    defer right.deinit();

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        var parts = std.mem.splitSequence(u8, line, "   ");

        const l = try std.fmt.parseInt(t, parts.next().?, 10);
        const r = try std.fmt.parseInt(t, parts.next().?, 10);

        try left.append(l);
        try right.append(r);
    }

    std.mem.sort(t, left.items, {}, comptime std.sort.asc(t));
    std.mem.sort(t, right.items, {},comptime std.sort.asc(t));

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
