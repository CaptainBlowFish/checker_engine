import copy


class checkerBoard:
    """Makes a standard 8x8 checker board"""
    def __init__(self):
        self.board_size = 8  # standard checker board size
        self.blank_piece = {"red": False, "black": False, "king": False}
        self.red_turn = True
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

    def print_board(self):
        
        row_num = 0
        print("———A———B———C———D———E———F———G———H——")
        for row in self.board:

            line = f"{row_num}| "
            row_num += 1

            for column in row:

                if column["red"]:
                    line += "R | "
                elif column["black"]:
                    line += "B | "
                else:
                    line += "  | "

            print(line)
            print("——————————————————————————————————")

    def get_movable_pieces(self):
        """returns a list of the locations of pieces that can be moved"""
        movable_pieces = []

        for piece in self.get_player_pieces():
            row, column = piece[0], piece[1]
            
            if self.board[row][column]["king"]:
                movable = (self.__check_empty_above__(row, column) or
                           self.__check_empty_below__(row, column) or
                           self.__check_capture_above__(row, column) or
                           self.__check_capture_below__(row, column))
            elif self.board[row][column]["black"]:
                movable = (self.__check_empty_below__(row, column) or
                           self.__check_capture_below__(row, column))
            else:
                movable = (self.__check_empty_above__(row, column) or
                           self.__check_capture_above__(row, column))
            if movable:
                movable_pieces.append(piece)
        return movable_pieces

    def get_all_pieces(self):
        possible_pieces = []
        for row in range(self.board_size):
            for column in range(self.board_size):
                if (self.board[row][column]["black"] or
                        self.board[row][column]["red"]):
                    possible_pieces.append([row, column])

        return possible_pieces

    def get_player_pieces(self):
        possible_pieces = []
        for row in range(self.board_size):
            for column in range(self.board_size):
                if self.board[row][column]["red"] and self.red_turn:
                    possible_pieces.append([row, column])
                elif self.board[row][column]["black"] and not self.red_turn:
                    possible_pieces.append([row, column])

        return possible_pieces

    def __check_capture_above__(self, row, column):
        """Checks above a given piece if there is any space to move to"""
        can_capture = False
        if self.board[row][column]["red"]:
            if column < self.board_size-2 and row > 1:
                if self.board[row-1][column+1]["black"] and (
                        not self.board[row-2][column+2]["red"] and
                        not self.board[row-2][column+2]["black"]):
                    can_capture = True
            elif column > 1 and row > 1:
                if self.board[row-1][column-1]["black"] and (
                        not self.board[row-2][column-2]["red"] and
                        not self.board[row-2][column-2]["black"]):
                    can_capture = True

        elif self.board[row][column]["black"]:
            if column < self.board_size-2 and row > 1:
                if self.board[row-1][column+1]["red"] and (
                        not self.board[row-2][column+2]["red"] and
                        not self.board[row-2][column+2]["black"]):
                    can_capture = True
            elif column > 1 and row > 1:
                if self.board[row-1][column-1]["red"] and (
                        not self.board[row-2][column-2]["red"] and
                        not self.board[row-2][column-2]["black"]):
                    can_capture = True

        return can_capture

    def __check_capture_below__(self, row, column):
        """Checks above a given piece if there is any space to move to"""
        can_capture = False
        if self.board[row][column]["red"]:
            if column < self.board_size-2 and row < self.board_size-2:
                if self.board[row+1][column+1]["black"] and (
                        not self.board[row+2][column+2]["red"] and
                        not self.board[row+2][column+2]["black"]):
                    can_capture = True
            elif column > 1 and row < self.board_size-2:
                if self.board[row+1][column-1]["black"] and (
                        not self.board[row+2][column-2]["red"] and
                        not self.board[row-2][column-2]["black"]):
                    can_capture = True

        elif self.board[row][column]["black"]:
            if column < self.board_size-2 and row < self.board_size-2:
                if self.board[row+1][column+1]["red"] and (
                        not self.board[row+2][column+2]["red"] and
                        not self.board[row+2][column+2]["black"]):
                    can_capture = True
            elif column > 1 and row < self.board_size-2:
                if self.board[row+1][column-1]["red"] and (
                        not self.board[row+2][column-2]["red"] and
                        not self.board[row+2][column-2]["black"]):
                    can_capture = True

        return can_capture

    def __check_empty_above__(self, row, column):
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

    def __check_empty_below__(self, row, column):
        """Checks above a given piece if there is any space to move to"""
        movable = False
        if column < self.board_size-1 and row < self.board_size-1:
            if (not self.board[row+1][column+1]["red"] and
                    not self.board[row+1][column+1]["black"]):
                movable = True
        if column > 0 and row < self.board_size-1:
            if (not self.board[row+1][column-1]["red"] and
                    not self.board[row+1][column-1]["black"]):
                movable = True

        return movable

    def __get_capture_above__(self, row, column):
        """Checks above a given piece if there is any space to move to"""
        end_spaces, captures = [], []
        if self.board[row][column]["red"]:
            if column < self.board_size-2 and row > 1:
                if self.board[row-1][column+1]["black"] and (
                        not self.board[row-2][column+2]["red"] and
                        not self.board[row-2][column+2]["black"]):
                    captures.append([row-1, column+1])
                    end_spaces.append([row-2, column+2])
            elif column > 1 and row > 1:
                if self.board[row-1][column-1]["black"] and (
                        not self.board[row-2][column-2]["red"] and
                        not self.board[row-2][column-2]["black"]):
                    captures.append([row-1, column-1])
                    end_spaces.append([row-2, column-2])

        elif self.board[row][column]["black"]:
            if column < self.board_size-2 and row > 1:
                if self.board[row-1][column+1]["red"] and (
                        not self.board[row-2][column+2]["red"] and
                        not self.board[row-2][column+2]["black"]):
                    captures.append([row-1, column+1])
                    end_spaces.append([row-2, column+2])
            elif column > 1 and row > 1:
                if self.board[row-1][column-1]["red"] and (
                        not self.board[row-2][column-2]["red"] and
                        not self.board[row-2][column-2]["black"]):
                    captures.append([row-1, column-1])
                    end_spaces.append([row-2, column-2])

        return end_spaces, captures

    def __get_capture_below__(self, row, column):
        """Checks above a given piece if there is any space to move to"""
        end_spaces, captures = [], []
        if self.board[row][column]["red"]:
            if column < self.board_size-2 and row < self.board_size-2:
                if self.board[row+1][column+1]["black"] and (
                        not self.board[row+2][column+2]["red"] and
                        not self.board[row+2][column+2]["black"]):
                    captures.append([row+1, column+1])
                    end_spaces.append([row+2, column+2])
            elif column > 1 and row < self.board_size-2:
                if self.board[row+1][column-1]["black"] and (
                        not self.board[row+2][column-2]["red"] and
                        not self.board[row-2][column-2]["black"]):
                    captures.append([row+1, column-1])
                    end_spaces.append([row+2, column-2])

        elif self.board[row][column]["black"]:
            if column < self.board_size-2 and row < self.board_size-2:
                if self.board[row+1][column+1]["red"] and (
                        not self.board[row+2][column+2]["red"] and
                        not self.board[row+2][column+2]["black"]):
                    captures.append([row+1, column+1])
                    end_spaces.append([row+2, column+2])
            elif column > 1 and row < self.board_size-2:
                if self.board[row+1][column-1]["red"] and (
                        not self.board[row+2][column-2]["red"] and
                        not self.board[row+2][column-2]["black"]):
                    captures.append([row+1, column-1])
                    end_spaces.append([row+2, column-2])

        return end_spaces, captures

    def __get_empty_above__(self, row, column):
        """returns empty spaces that the given piece can move to"""
        spaces = []
        if column < self.board_size-1 and row > 0:
            if (not self.board[row-1][column+1]["red"] and
                    not self.board[row-1][column+1]["black"]):
                spaces.append([row-1, column+1])
        if column > 0 and row > 0:
            if (not self.board[row-1][column-1]["red"] and
                    not self.board[row-1][column-1]["black"]):
                spaces.append([row-1, column-1])

        return spaces

    def __get_empty_below__(self, row, column):
        """returns empty spaces that the given piece can move to"""
        spaces = []
        if column < self.board_size-1 and row < self.board_size-1:
            if (not self.board[row+1][column+1]["red"] and
                    not self.board[row+1][column+1]["black"]):
                spaces.append([row+1, column+1])
        if column > 0 and row < self.board_size-1:
            if (not self.board[row+1][column-1]["red"] and
                    not self.board[row+1][column-1]["black"]):
                spaces.append([row+1, column-1])

        return spaces


if __name__ == "__main__":
    game = checkerBoard()

    for row in game.board:
        for piece in row:
            piece["red"] = False
            piece["black"] = False

    game.board[3][2]["red"] = True
    game.board[2][3]["black"] = True

    game.print_board()

    for piece in game.get_movable_pieces():
        print(piece)
