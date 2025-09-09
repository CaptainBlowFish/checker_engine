import checker_board
import random


class basicBot(checker_board.checkerBoard):
    """The 'easy' checkers bot. This will be not using much of any stratagy.
    Just moving randomly and capturing when possible"""
    
    def bot_move(self):
        random.shuffle(self.movable_pieces)
        for piece in self.movable_pieces:
            if (self.board[piece[0]][piece[1]]["red"] or self.board[piece[0]][piece[1]]["king"]) and self.__check_capture_above__(piece[0], piece[1]):
                possible_destinations, possible_captures = self.__get_capture_above__(piece[0], piece[1])
                destination = random.choice(possible_destinations)
                self.move_piece(piece[0], piece[1], destination[0], destination[1])
                break
            if (self.board[piece[0]][piece[1]]["black"] or self.board[piece[0]][piece[1]]["king"]) and self.__check_capture_below__(piece[0], piece[1]):
                possible_destinations, possible_captures = self.__get_capture_below__(piece[0], piece[1])
                destination = random.choice(possible_destinations)
                self.move_piece(piece[0], piece[1], destination[0], destination[1])
                break
        else:
            for piece in self.movable_pieces:
                if (self.board[piece[0]][piece[1]]["red"] or self.board[piece[0]][piece[1]]["king"]) and self.__check_empty_above__(piece[0], piece[1]):
                    possible_destinations = self.__get_empty_above__(piece[0], piece[1])
                    destination = random.choice(possible_destinations)
                    self.move_piece(piece[0], piece[1], destination[0], destination[1])
                    break
                elif (self.board[piece[0]][piece[1]]["black"] or self.board[piece[0]][piece[1]]["king"]) and self.__check_empty_below__(piece[0], piece[1]):
                    possible_destinations = self.__get_empty_below__(piece[0], piece[1])
                    destination = random.choice(possible_destinations)
                    self.move_piece(piece[0], piece[1], destination[0], destination[1])
