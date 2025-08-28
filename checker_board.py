import copy


class checkerBoard:
    """Makes a standard 8x8 checker board"""
    def __init__(self):
        self.board_size = 8  # standard checker board size
        self.pieces = ["red", "black"]
        self.blank_piece = {"red": False, "black": False, "king": False}
        self.make_board()
        self.setup_board()

    def make_board(self):
        self.board = []

        for row in range(self.board_size):
            self.board.append([])
            for column in range(self.board_size):
                self.board[row].append(copy.deepcopy(self.blank_piece))

    def setup_board(self, rows_per_side=3):
        offset = False
        for row in range(rows_per_side):
            offset = not offset
            for column in range(0, self.board_size, 2):
                self.board[row][column+offset]["black"] = True
        self.board.reverse()

        offset = True
        for row in range(rows_per_side):
            offset = not offset
            for column in range(0, self.board_size, 2):
                self.board[row][column+offset]["red"] = True
        self.board.reverse()

    def get_movable_pieces(self):
        """returns a list of the locations of pieces that can be moved"""
        movable_pieces = []

        for piece in self.get_all_pieces():
            row, column = piece[0], piece[1]
            if "king" in self.board[row][column]:
                movable = (self.__check_above__(row, column) or
                           self.__check_below__(row, column))
            elif (self.board[row][column] ==
                    self.pieces[0]):
                movable = self.__check_below__(row, column)
            else:
                movable = self.__check_above__(row, column)

            if movable:
                movable_pieces.append(piece)
        return movable_pieces

    def get_all_pieces(self):
        possible_pieces = []
        for row in range(self.board_size):
            for column in range(self.board_size):
                if self.board[row][column] in self.pieces:
                    possible_pieces.append([row, column])

        return possible_pieces

    def __check_above__(self, row, column):
        """Checks above a given piece if there is any space to move to"""
        movable = False
        if column < self.board_size-1 and row > 0:
            if (not self.board[row-1][column+1]["red"] and
                    not self.board[row-1][column+1]["black"]):
                movable = True
        if column > 0 and row > 0:
            if (not self.board[row-1][column-1]["red"] and
                    not self.board[row-1][column-1]["black"]):
                movable = True
        return movable

    def __check_below__(self, row, column):
        """Checks above a given piece if there is any space to move to"""
        movable = False
        if column < self.board_size-1 and row < self.board_size-1:
            if (self.board[row+1][column+1] !=
                    self.pieces[0]) and (
                    self.board[row+1][column+1] !=
                    self.pieces[1]):
                movable = True
        if column > 0 and row < self.board_size-1:
            if (self.board[row+1][column-1] !=
                    self.pieces[0]) and (
                    self.board[row+1][column-1] !=
                    self.pieces[1]):
                movable = True
        return movable


if __name__ == "__main__":
    game = checkerBoard()
