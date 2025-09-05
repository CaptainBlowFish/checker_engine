import checker_board
import pygame


class television:
    """Displays the game board."""
    def __init__(self):
        self.pygame = pygame.init()
        self.screen = pygame.display.set_mode((550, 400), pygame.RESIZABLE |
                                              pygame.SCALED)
        self.clock = pygame.time.Clock()
        self.running = True
        self.game = checker_board.checkerBoard()
        self.freetype = pygame.freetype.init()

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

    def display_board(self):
        while self.running:
            self.grab_input()
            self.screen.fill("white")
            white_square = False
            counter = 0

            # makes the checkerboard
            for row in self.checker_board:
                for square in row:
                    if counter % self.game.board_size == 0:
                        white_square = not white_square
                    counter += 1
                    if not white_square:
                        pygame.draw.rect(self.screen, "grey", square)
                    white_square = not white_square

            for piece in self.game.get_all_pieces():
                if self.game.board[piece[0]][piece[1]]["black"]:
                    self.pieces.append(pygame.draw.circle(self.screen, "black",
                                       (25+piece[1]*50, 25+piece[0]*50), 20))
                else:
                    self.pieces.append(pygame.draw.circle(self.screen, "red",
                                       (25+piece[1]*50, 25+piece[0]*50), 20))

            pygame.display.flip()
            self.clock.tick(60)

        pygame.quit()

    def grab_input(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                mouse_x, mouse_y = pygame.mouse.get_pos()
                for row in range(len(self.checker_board)):
                    for column in range(len(self.checker_board[row])):
                        if pygame.Rect.collidepoint(self.checker_board[row][column], mouse_y, mouse_x) and [row,column] in self.game.movable_pieces:
                            self.chosen_piece['row'] = row
                            self.chosen_piece['column'] = column
                        elif pygame.Rect.collidepoint(self.checker_board[row][column], mouse_y, mouse_x):
                            self.game.move_piece(self.chosen_piece['row'],self.chosen_piece['column'],row,column)


            self.game.move_piece(5, 0, 4, 1)


if __name__ == "__main__":
    game = television()
    game.display_board()
