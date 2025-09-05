import copy


class checkerBoard:
    """Makes a standard 8x8 checker board"""
    def __init__(self):
        self.board_size = 8  # standard checker board size
        self.blank_piece = {"red": False, "black": False, "king": False}
        self.red_turn = True
        self.make_board()
        self.setup_board()
        self.movable_pieces = self.get_movable_pieces()

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
        print("———0———1———2———3———4———5———6———7——")
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

    def move_piece(self, row, column, destination_row, destination_column):
        """Will move the given piece to the destination if it is a legal move"""
        complete_move = False
        captured = False
        if [row, column] in self.movable_pieces:
            if destination_row > row and (self.board[row][column]["black"] or
                                          self.board[row][column]["king"]):
                if abs(destination_column - column) == 1 and [destination_row, destination_column] in self.__get_empty_below__(row, column):
                    complete_move = True
                elif abs(destination_column - column) == 2:
                    possible_end_spaces, captures = self.__get_capture_below__(row, column)
                    if [destination_row, destination_column] in possible_end_spaces:
                        if destination_column > column:
                            self.board[row+1][column+1] = copy.deepcopy(self.blank_piece)
                            complete_move = True
                            captured = True
                        else:
                            self.board[row+1][column-1] = copy.deepcopy(self.blank_piece)
                            complete_move = True
                            captured = True
            if destination_row < row and (self.board[row][column]["red"] or
                                          self.board[row][column]["king"]):
                if abs(destination_column - column) == 1 and [destination_row, destination_column] in self.__get_empty_above__(row, column):
                    complete_move = True
                elif abs(destination_column - column) == 2:
                    possible_end_spaces, captures = self.__get_capture_above__(row, column)
                    if [destination_row, destination_column] in possible_end_spaces:
                        if destination_column > column:
                            self.board[row-1][column+1] = copy.deepcopy(self.blank_piece)
                            complete_move = True
                            captured = True
                        else:
                            self.board[row-1][column-1] = copy.deepcopy(self.blank_piece)
                            complete_move = True
                            captured = True

        
        if complete_move:
            self.board[destination_row][destination_column] = copy.deepcopy(self.board[row][column])
            self.board[row][column] = copy.deepcopy(self.blank_piece)
            if not captured:
                self.red_turn = not self.red_turn
                self.movable_pieces = self.get_movable_pieces()
        
        if captured:
            if (self.board[destination_row][destination_column]["black"] or self.board[destination_row][destination_column]["king"]) and self.__check_capture_below__(destination_row, destination_column):
                self.movable_pieces = [[destination_row, destination_column]]
            elif (self.board[destination_row][destination_column]["red"] or self.board[destination_row][destination_column]["king"]) and self.__check_capture_above__(destination_row, destination_column): 
                self.movable_pieces = [[destination_row, destination_column]]
            else:
                self.red_turn = not self.red_turn
                self.movable_pieces = self.get_movable_pieces()

    def get_all_pieces(self):
        possible_pieces = []
        for row in range(self.board_size):
            for column in range(self.board_size):
                if (self.board[row][column]["black"] or self.board[row][column]["red"]):
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

    while True:
        if game.red_turn:
            print("red Turn")
        else:
            print("black Turn")
        game.print_board()
        
        game.move_piece(5, 0, 4, 1)
        print([4, 1] in game.__get_empty_above__(5, 0))
        print(input("yay"))
