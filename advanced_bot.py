import checker_board
import basic_bot
import copy

class advancedBot(basic_bot.basicBot):
    """The 'hard' checkers bot. This uses a strategy that looks a few moves ahead."""
    def __init__(self):
        super().__init__()
        self.captured_rating = 10
        self.lost_piece_rating = 10
        self.no_capture_rating = 1
        self.failures = 0

    def get_possible_moves(self, row, column):
        """ Returns a list of all the possible moves a piece can make"""
        possible_moves = []
        if self.board[row][column]["black"] or self.board[row][column]["king"]:
            if self.__check_capture_below__(row, column):
                captures = self.__get_capture_below__(row, column)
                possible_moves.append(captures[0])
            if self.__check_empty_below__(row, column):
                possible_moves.append(self.__get_empty_below__(row, column))
        if self.board[row][column]["red"] or self.board[row][column]["king"]:
            if self.__check_capture_above__(row, column):
                captures = self.__get_capture_above__(row, column)
                possible_moves.append(captures[0])
            if self.__check_empty_above__(row, column):
                possible_moves.append(self.__get_empty_above__(row, column))

        return possible_moves

    def __get_typed_possible_moves__(self, row, column):
        """ Returns a dictionary of all the possible moves a piece can make"""
        possible_moves = {"captures": [],
                          "empties": []}
        if self.board[row][column]["black"] or self.board[row][column]["king"]:
            if self.__check_capture_below__(row, column):
                captures = self.__get_capture_below__(row, column)
                possible_moves["captures"].append(captures[0])
            if self.__check_empty_below__(row, column):
                possible_moves["empties"].append(self.__get_empty_below__(row, column))
        if self.board[row][column]["red"] or self.board[row][column]["king"]:
            if self.__check_capture_above__(row, column):
                captures = self.__get_capture_above__(row, column)
                possible_moves["captures"].append(captures[0])
            if self.__check_empty_above__(row, column):
                possible_moves["empties"].append(self.__get_empty_above__(row, column))

        return possible_moves

    def bot_move(self):
        best_rating = 0
        for piece in range(len(self.movable_pieces)):
            move, rating = self.get_best_move_for_piece(self.movable_pieces[piece])
            if rating >= best_rating:
                best_rating = rating
                best_move = move
        
        self.move_piece(best_move[0], best_move[1], best_move[2], best_move[3])

    def get_best_move_for_piece(self, piece):
        best_move = []
        best_rating = 0
        possible_moves = self.get_possible_moves(piece[0], piece[1])
        for move in range(len(possible_moves)):
            best_move, best_rating = self.test_moves(piece, best_rating, possible_moves, move)
        
        return best_move, best_rating

    def test_moves(self, piece, best_rating, possible_moves, move):
        for move in range(len(possible_moves)):
            rating = 0
            self.test = copy.deepcopy(self)
            rating += self.__rate_board_position__()
            self.test.move_piece(piece[0], piece[1], possible_moves[move][0][0], possible_moves[move][0][1])
            rating -= self.__rate_opp_board_position__()
            delattr(self, 'test')
            if rating >= best_rating:
                best_rating = rating
                best_move = [piece[0], piece[1], possible_moves[move][0][0], possible_moves[move][0][1]]
        return best_move, best_rating

    def __rate_piece__(self, row, column, capture_modifyer):
        """ Returns the rating of moving a piece"""
        rating = 0
        possible_moves = self.__get_typed_possible_moves__(row, column)
        rating += len(possible_moves["captures"]) * capture_modifyer
        rating += len(possible_moves["empties"]) * self.no_capture_rating

        return rating

    def __rate_board_position__(self):
        """ Gives a rating based on the current state of movable pieces on the board."""
        rating = 0
        for piece in self.movable_pieces:
            rating += self.__rate_piece__(piece[0], piece[1], self.captured_rating)

        return rating

    def __rate_opp_board_position__(self):
        """ Gives a rating based on the current state of movable pieces on the opponent's board."""
        rating = 0
        for piece in self.movable_pieces:
            rating += self.__rate_piece__(piece[0], piece[1], self.lost_piece_rating)

        return rating

if __name__ == "__main__":
    game = advancedBot()
    while not (game.red_win or game.black_win):
        game.bot_move()
        game.print_board()