import checker_board
import pygame


class television:
    """Displays the game board."""
    def __init__(self):
        self.pygame = pygame.init()
        self.screen = pygame.display.set_mode((400, 300), pygame.RESIZABLE |
                                              pygame.SCALED)
        self.clock = pygame.time.Clock()
        self.running = True
        self.game_board = checker_board.checkerBoard()

    def display_board(self):
        while self.running:
            self.grab_input()
            self.screen.fill("white")
            board = pygame.rect.Rect(0, 0, 300, 300)
            pygame.draw.rect(self.screen, "grey", board)
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
    game.display_board()