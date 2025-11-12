import pygame
import bill_board
import advanced_bot
import button


class television:
    """Displays the game board."""
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((550, 400), pygame.RESIZABLE |
                                              pygame.SCALED)
        self._clock = pygame.time.Clock()
        self._running = True
        # self.game = basic_bot.basicBot()
        self.game = advanced_bot.advancedBot()
        self._play_again_button = button.Button(self, "play again?")
        self._black_turn_label = bill_board.billBoard(self, "Black Turn")
        self._red_turn_label = bill_board.billBoard(self, "Red Turn")
        self._black_won_label = bill_board.billBoard(self, "Black won")
        self._red_won_label = bill_board.billBoard(self, "Red won")

        self._checker_board = []
        self._pieces = []
        self._square_size = 50
        self._chosen_piece = {"row": -1, "column": -1}  # -1 is my flag value
        for width in range(self.game.board_size):
            self._checker_board.append([])
            for height in range(self.game.board_size):
                self._checker_board[width].append(pygame.rect.Rect(
                    width * self._square_size, height * self._square_size,
                    self._square_size, self._square_size))

    def draw_screen(self):
        while self._running:
            self.screen.fill("white")
            self.draw_board()
            self.draw_pieces()

            if not self.game.black_win and not self.game.red_win:
                # Dictates which color each player will be
                if self.game.red_turn:  # Red player
                    self.grab_input()
                else:  # Black player
                    self.game.bot_move()
                
                if self.game.red_turn:
                    self._red_turn_label.draw()
                else:
                    self._black_turn_label.draw()
            else:
                if self.game.black_win:
                    self._black_won_label.draw()
                if self.game.red_win:
                    self._red_won_label.draw()

                self._play_again_button.draw_button()
                print(self.game.failures)
                print(self.game.turns)
                self.grab_input()
            
            pygame.display.flip()
            self._clock.tick(5)

        pygame.quit()

    def draw_board(self):
        white_square = False
        counter = 0
        for row in self._checker_board:
            for square in row:
                if counter % self.game.board_size == 0:
                    white_square = not white_square
                counter += 1
                if white_square:
                    pygame.draw.rect(self.screen, "white", square)
                else:
                    pygame.draw.rect(self.screen, "grey", square)
                white_square = not white_square

    def draw_pieces(self):
        for piece in self.game.get_all_pieces():
            if self.game.board[piece[0]][piece[1]]["black"]:
                self._pieces.append(pygame.draw.circle(self.screen, "black",
                    (25+piece[1]*50, 25+piece[0]*50), 20))
            else:
                self._pieces.append(pygame.draw.circle(self.screen, "red",
                    (25+piece[1]*50, 25+piece[0]*50), 20))
            if self.game.board[piece[0]][piece[1]]["king"]:
                self._pieces.append(pygame.draw.circle(self.screen, "white",
                    (25+piece[1]*50, 25+piece[0]*50), 10))

    def grab_input(self):
        for event in pygame.event.get():
            if event.type == pygame.MOUSEBUTTONDOWN:
                mouse_x, mouse_y = pygame.mouse.get_pos()
                if self.game.black_win or self.game.red_win:
                    if pygame.Rect.collidepoint(self._play_again_button.rect, mouse_x, mouse_y):
                        self.game.__init__()
                self.check_board_click(mouse_x, mouse_y)
                print(self.game.movable_pieces)
            elif event.type == pygame.QUIT:
                self._running = False

    def check_board_click(self, mouse_x, mouse_y):
        for row in range(len(self._checker_board)):
            for column in range(len(self._checker_board[row])):
                if pygame.Rect.collidepoint(self._checker_board[row][column], mouse_y, mouse_x) and [row,column] in self.game.movable_pieces:
                    self._chosen_piece['row'] = row
                    self._chosen_piece['column'] = column
                elif pygame.Rect.collidepoint(self._checker_board[row][column],
                                              mouse_y, mouse_x):
                    self.game.move_piece(self._chosen_piece['row'],
                                         self._chosen_piece['column'],
                                         row, column)


if __name__ == "__main__":
    game = television()
    game.game.make_board()
    game.game.setup_board()
    game.draw_screen()
