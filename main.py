import checker_board
import pygame


class television:
    """Displays the game board."""
    def __init__(self):
        self.pygame = pygame.init()
        self.screen = pygame.display.set_mode((800, 600))
        self.clock = pygame.time.Clock()
        self.running = True
        self.game_board = checker_board.checkerBoard()

    def print_board(self):
        for row in self.game_board.board:
            line = "| "

            for column in row:

                if column["red"]:
                    line += "R | "
                elif column["black"]:
                    line += "B | "
                else:
                    line +="  | "

            print("——————————————————————————————————")
            print(line)

    def display_board(self):
        while self.running:
            self.grab_input()
            self.screen.fill("purple")
            pygame.display.flip()
            self.clock.tick(60)

        pygame.quit()

    def grab_input(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                pygame.mouse.get_pos()


if __name__ == "__main__":
    game = television()
    game.print_board()
    game.display_board()
