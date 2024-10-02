const std = @import("std");
const Board = @import("representation/board.zig");
const view = @import("view.zig");

const Allocator = std.mem.Allocator;

const STARTING_FEN = Board.STARTING_FEN;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();

    var board = try Board.from(allocator, STARTING_FEN);
    defer board.deinit();

    view.print(board);
}
