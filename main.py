import pygame
import bill_board
import basic_bot
import advanced_bot
import button


class television:
    """Displays the game board."""
    def __init__(self):
        self.pygame = pygame.init()
        self.screen = pygame.display.set_mode((550, 400), pygame.RESIZABLE |
                                              pygame.SCALED)
        self.clock = pygame.time.Clock()
        self.running = True
        #self.game = basic_bot.basicBot()
        self.game = advanced_bot.advancedBot()
        self.play_again_button = button.Button(self, "play again?")
        self.black_turn_label = bill_board.billBoard(self, "Black Turn")
        self.red_turn_label = bill_board.billBoard(self, "Red Turn")
        self.black_won_label = bill_board.billBoard(self, "Black won")
        self.red_won_label = bill_board.billBoard(self, "Red won")

        self.checker_board = []
        self.pieces = []
        self.square_size = 50
        self.chosen_piece = {"row": -1, "column": -1}  # -1 is my flag value
        for width in range(self.game.board_size):
            self.checker_board.append([])
            for height in range(self.game.board_size):
                self.checker_board[width].append(pygame.rect.Rect(
                    width * self.square_size, height * self.square_size,
                    self.square_size, self.square_size))

    def draw_screen(self):
        while self.running:
            self.screen.fill("white")
            self.draw_board()
            self.draw_pieces()

            if not self.game.black_win and not self.game.red_win:
                # Dictates which color each player will be
                if self.game.red_turn:  # Red player
                    self.grab_input()
                    self.game.bot_move()
                else:  # Black player
                    self.game.bot_move()
                
                if self.game.red_turn:
                    self.red_turn_label.draw()
                else:
                    self.black_turn_label.draw()
            else:
                if self.game.black_win:
                    self.black_won_label.draw()
                if self.game.red_win:
                    self.red_won_label.draw()

                self.play_again_button.draw_button()
                print(self.game.failures)
                print(self.game.turns)
                quit()
                self.grab_input()
            
            pygame.display.flip()
            #self.clock.tick(60)

        pygame.quit()

    def draw_board(self):
        white_square = False
        counter = 0
        for row in self.checker_board:
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
                self.pieces.append(pygame.draw.circle(self.screen, "black",
                    (25+piece[1]*50, 25+piece[0]*50), 20))
            else:
                self.pieces.append(pygame.draw.circle(self.screen, "red",
                    (25+piece[1]*50, 25+piece[0]*50), 20))
            if self.game.board[piece[0]][piece[1]]["king"]:
                self.pieces.append(pygame.draw.circle(self.screen, "white",
                    (25+piece[1]*50, 25+piece[0]*50), 10))

    def grab_input(self):
        for event in pygame.event.get():
            if event.type == pygame.MOUSEBUTTONDOWN:
                mouse_x, mouse_y = pygame.mouse.get_pos()
                if self.game.black_win or self.game.red_win:
                    if pygame.Rect.collidepoint(self.play_again_button.rect, mouse_x, mouse_y):
                        self.game.__init__()
                self.check_board_click(mouse_x, mouse_y)
            elif event.type == pygame.QUIT:
                self.running = False

    def check_board_click(self, mouse_x, mouse_y):
        for row in range(len(self.checker_board)):
            for column in range(len(self.checker_board[row])):
                if pygame.Rect.collidepoint(self.checker_board[row][column], mouse_y, mouse_x) and [row,column] in self.game.movable_pieces:
                    self.chosen_piece['row'] = row
                    self.chosen_piece['column'] = column
                elif pygame.Rect.collidepoint(self.checker_board[row][column], mouse_y, mouse_x):
                    self.game.move_piece(self.chosen_piece['row'], self.chosen_piece['column'], row, column)

if __name__ == "__main__":
    game = television()
    game.draw_screen()
