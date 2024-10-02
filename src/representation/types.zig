const std = @import("std");

pub const PieceKind = enum {
    Pawn,
    Rook,
    Knight,
    Bishop,
    Queen,
    King,
};

pub const Color = enum {
    Black,
    White
};

pub const Piece = struct {
    kind: PieceKind,
    color: Color,

    pub fn from(chr: u8) ?Piece {
        const kind: ?PieceKind = switch (std.ascii.toLower(chr)) {
            'p' => .Pawn,
            'r' => .Rook,
            'n' => .Knight,
            'b' => .Bishop,
            'q' => .Queen,
            'k' => .King,
            else => null
        };
        if (kind == null) return null;
        return .{
            .kind = kind orelse unreachable,
            .color = if (std.ascii.isUpper(chr)) .Black else .White
        };
    }
};

pub const State = enum {
    playing,
    checkmate,
    check
};

pub const HalfMove = struct {

};
