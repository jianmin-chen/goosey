const std = @import("std");
const Board = @import("representation/board.zig");

pub fn print(board: Board) void {
    for (board.board, 0..) |row, opposite_rank| {
        _ = row;
        const rank = 8 - opposite_rank;
        std.debug.print("{d} ", .{rank});
        std.debug.print("\n", .{});
    }

    std.debug.print("  ", .{});

    for (97..105) |file| {
        std.debug.print("{c} ", .{@as(u8, @intCast(file))});
    }

    std.debug.print("\n", .{});
}
