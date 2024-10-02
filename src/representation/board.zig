const std = @import("std");
const types = @import("types.zig");

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub const Board = [8][8]?Piece;
const Color = types.Color;
const Piece = types.Piece;
const PieceKind = types.PieceKind;

pub const STARTING_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

pub const BoardError = error{InvalidNotation};

const Self = @This();

allocator: Allocator,
history: ArrayList(Board),
board: Board = emptyBoard(),
side: Color = .White,
castling: u4 = 0b1111,
en_passant: ?[]const u8 = null,
halfmove_clock: u8 = 0,
moves: usize = 0,

pub fn from(allocator: Allocator, fen: []const u8) !Self {
    var self: Self = .{
        .allocator = allocator,
        .history = ArrayList(Board).init(allocator)
    };

    var repr = std.mem.splitScalar(u8, fen, ' ');

    if (repr.next()) |piece_placement| {
        var ranks = std.mem.splitScalar(u8, piece_placement, '/');
        var idx: u8 = 0;
        while (ranks.next()) |rank| {
            for (rank, 0..) |chr, file| {
                if (file > 7) return BoardError.InvalidNotation;
                if (chr == '8') continue;
                if (Piece.from(chr)) |piece| {
                    self.board[7 - idx][file] = piece;
                } else return BoardError.InvalidNotation;
            }
            idx += 1;
        }

        if (idx != 8) return BoardError.InvalidNotation;
    } else return BoardError.InvalidNotation;

    if (repr.next()) |side_to_move| {
        if (side_to_move.len > 1) return BoardError.InvalidNotation;
        switch (side_to_move[0]) {
            'w' => {},
            'b' => {
                self.side = .Black;
            },
            else => return BoardError.InvalidNotation
        }
    } else return BoardError.InvalidNotation;

    if (repr.next()) |castling_ability| {
        for (castling_ability) |castling| {
            switch (castling) {
                'K' => {
                    self.castling |= 0b1000;
                },
                'Q' => {
                    self.castling |= 0b0100;
                },
                'k' => {
                    self.castling |= 0b0010;
                },
                'q' => {
                    self.castling |= 0b0001;
                },
                '-' => {
                    self.castling = 0;
                    if (castling_ability.len > 1) return BoardError.InvalidNotation;
                    break;
                },
                else => return BoardError.InvalidNotation
            }
        }
    } else return BoardError.InvalidNotation;

    if (repr.next()) |en_passant_location| {
        self.en_passant = en_passant_location;
    } else return BoardError.InvalidNotation;

    if (repr.next()) |halfmove_counter| {
        self.halfmove_clock = std.fmt.parseInt(u8, halfmove_counter, 10) catch {
            return BoardError.InvalidNotation;
        };
    } else return BoardError.InvalidNotation;

    if (repr.next()) |fullmove_counter| {
        self.moves = std.fmt.parseInt(usize, fullmove_counter, 10) catch {
            return BoardError.InvalidNotation;
        };
    } else return BoardError.InvalidNotation;

    if (repr.next() != null) return BoardError.InvalidNotation;

    try self.history.append(self.board);
    return self;
}

pub fn deinit(self: *Self) void {
    self.history.deinit();
}

pub fn emptyBoard() Board {
    return [_][8]?Piece{
        [_]?Piece{null} ** 8
    } ** 8;
}

pub fn legalMoves(self: *Self) void {
    _ = self;
}
